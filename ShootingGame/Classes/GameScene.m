//
//  GameScene.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameScene.h"
#import "BulletCache.h"
#import "EnemyCache.h"
#import "InputLayer.h"
#import "checkDeviceConfig.h"
#import "ScoreComponent.h"
#import "EnemyEntity.h"
#import "ParallaxBackground.h"
#import "ShipEntity.h"

@interface GameScene(PreivateMethods)
- (void)countBullets:(CCTime)delta;
- (void)preloadParticleEffects:(NSString *)particleFile;
@end
// -----------------------------------------------------------------

@implementation GameScene

static CGRect screenRect;
static GameScene *instanceOfGameScene;

// -----------------------------------------------------------------
+ (id)scene{
    CCScene *scene = [CCScene node];
    GameScene *gameLayer = [GameScene node];
    [scene addChild:gameLayer z:0 name:@"GameSceneLayerTagGame"];
    InputLayer *inputLayer = [InputLayer node];
    [scene addChild:inputLayer z:1 name:@"GameSceneLayerTagInput"];
    scene.name = @"GameScene";
    return scene;
}

+ (GameScene *)shareGameScene{
    NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized");
    return instanceOfGameScene;
}

- (id)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        instanceOfGameScene = self;
        
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        screenRect = CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
        
        //添加所有的图片纹理集对应的plist文件
        CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        
//        NSString *iphoneVersion = [checkDeviceConfig deviceVersionInSimulator];
//        if ([iphoneVersion isEqualToString:@"iPhone 5"]) {
//            [frameCache addSpriteFramesWithFile:@"game-art.plist"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 5s"]){
//            [frameCache addSpriteFramesWithFile:@"game-art.plist"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 5c"]){
//            [frameCache addSpriteFramesWithFile:@"game-art.plist"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 6"]){
//            [frameCache addSpriteFramesWithFile:@"game-art1.plist"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 7"]){
//            [frameCache addSpriteFramesWithFile:@"game-art1.plist"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 6 Plus"]){
//            [frameCache addSpriteFramesWithFile:@"game-art2.plist"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 7 Plus"]){
//            [frameCache addSpriteFramesWithFile:@"game-art2.plist"];
//        }
        
        [frameCache addSpriteFramesWithFile:@"game-art.plist"];
        
        ParallaxBackground *background = [ParallaxBackground node];
        [self addChild:background z:-1];
        
        ShipEntity *ship = [ShipEntity ship];
        ship.position = CGPointMake(ship.contentSize.width * 0.5f, screenSize.height *0.5f);
        [self addChild:ship z:0 name:@"GameSceneNodeTagShip"];
        
        EnemyCache *enemyCache = [EnemyCache node];
        [self addChild:enemyCache z:0 name:@"GameSceneNodeTagEnemyCache"];
        
        BulletCache *preBulletCache = [BulletCache node];
        [self addChild:preBulletCache z:0 name:@"GameSceneNodeTagBulletCache"];
        
        //预加载粒子特效plist文件
        [self preloadParticleEffects:@"fx-explosion.plist"];
        [self preloadParticleEffects:@"fx-explosion2.plist"];
        
        ScoreComponent *score = [ScoreComponent node];
        [self addChild:score z:0 name:@"GameSceneNodeTagScore"];
        
        _backgroundSpriteAnim = [CCSprite spriteWithImageNamed:@"boss-showup-anim0.png"];
        _backgroundSpriteAnim.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
        [self addChild:_backgroundSpriteAnim z:0 name:@"GameSceneNodeTagBossShowupAnimBackgroundSprite"];
        _backgroundSpriteAnim.visible = NO;
        
        _bossShowupLabel = [CCSprite spriteWithImageNamed:@"boss-label.png"];
        _bossShowupLabel.position = CGPointMake(screenSize.width, screenSize.height * 0.5f);
        [self addChild:_bossShowupLabel];
        _bossShowupLabel.visible = NO;
        
        //添加背景音乐
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL *isBackgroundMusicOn = [defaults boolForKey:@"isBackgroundMusicOn"];
        if (isBackgroundMusicOn) {
            [[OALSimpleAudio sharedInstance] playBg:@"ShootingStarOfField.mp3" loop:YES];
        }
        
        //调试
        //self.scale = 0.5f;
        //self.anchorPoint = CGPointMake(-0.5f, -0.5f);
    }
    
    return self;
}

//- (void)dealloc{
//    instanceOfGameScene = nil;
//    [super dealloc];
//}

- (void)preloadParticleEffects:(NSString *)particleFile{
    [CCParticleSystem particleWithFile:particleFile];
}

- (BulletCache *)bulletCache{
    CCNode *node = [self getChildByName:@"GameSceneNodeTagBulletCache" recursively:YES];
    NSAssert([node isKindOfClass:[BulletCache class]], @"node is not a BulletCache");
    return (BulletCache *)node;
}

- (ShipEntity *)defaultShip{
    CCNode *node = [self getChildByName:@"GameSceneNodeTagShip" recursively:YES];
    NSAssert([node isKindOfClass:[ShipEntity class]], @"node is not a ShipEntity");
    return (ShipEntity *)node;
}

+ (CGRect)screenRect{
    return screenRect;
}

- (void)shakeGameSceneWithEnemyType:(EnemyTypes)type{
    CGPoint diffTop;
    CGPoint diffBottom;
    CGPoint diffLeft;
    CGPoint diffRight;
    CGPoint diffCenter;
    if (type == EnemyTypeBoss) {
        diffTop = CGPointMake(0.0f, 0.05f);
        diffBottom = CGPointMake(0.0f, -0.05f);
        diffLeft = CGPointMake(-0.05f, 0.0f);
        diffRight = CGPointMake(0.05f, 0.0f);
        diffCenter = CGPointMake(0.0f, 0.0f);
    }else{
        diffTop = CGPointMake(0.0f, 1.0f);
        diffBottom = CGPointMake(0.0f, -1.0f);
        diffLeft = CGPointMake(-1.0f, 0.0f);
        diffRight = CGPointMake(1.0f, 0.0f);
        diffCenter = CGPointMake(0.0f, 0.0f);
    }
    CGFloat duration = 0.03f;
    CCActionMoveTo *sceneMoveTop = [CCActionMoveTo actionWithDuration:duration position:diffTop];
    CCActionMoveTo *sceneMovebottom = [CCActionMoveTo actionWithDuration:duration position:diffBottom];
    CCActionMoveTo *sceneMoveLeft = [CCActionMoveTo actionWithDuration:duration position:diffLeft];
    CCActionMoveTo *sceneMoveRight = [CCActionMoveTo actionWithDuration:duration position:diffRight];
    CCActionMoveTo *sceneMoveCenter = [CCActionMoveTo actionWithDuration:duration position:diffCenter];
    CCActionSequence *actionSequence = [CCActionSequence actions:sceneMoveTop, sceneMoveRight, sceneMovebottom, sceneMoveLeft, sceneMoveCenter, nil];
    [self runAction:actionSequence];
}


// -----------------------------------------------------------------

@end





