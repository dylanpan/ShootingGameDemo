//
//  GameOverLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/15
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameOverLayer.h"
#import "GameScene.h"
#import "GameSettingLayer.h"
#import "GameStartLayer.h"
#import "ScoreComponent.h"

// -----------------------------------------------------------------

@implementation GameOverLayer

// -----------------------------------------------------------------
+ (id)scene{
    CCScene *scene = [CCScene node];
    GameOverLayer *gameOverLayer = [GameOverLayer node];
    [scene addChild:gameOverLayer z:0 name:@"GameSceneLayerTagGameLayer"];
    scene.name = @"GameOverLayer";
    return scene;
}

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        CCNodeColor *backgroundLayer = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:69.0f/255.0f green:137.0f/255.0f blue:148.0f/255.0f] width:screenSize.width height:screenSize.height];
        [self addChild:backgroundLayer];
        
        //生成目录项目：分数（score）、重新开始（restart）、游戏设置（setting）、返回主页（main）
        _restartButton = [self makeMeunItemWithLabelName:@"Restart" fontSize:32 heightScale:0.44f];
        _settingButton = [self makeMeunItemWithLabelName:@"Setting" fontSize:16 heightScale:0.3f];
        _mainButton = [self makeMeunItemWithLabelName:@"Main" fontSize:16 heightScale:0.2f];
        
        [self addScoreLabelWithScore:[NSString stringWithFormat:@"High Score:%ld",(long)[ScoreComponent getHighScore]] scale:0.8f];
        [self addScoreLabelWithScore:[NSString stringWithFormat:@"Score:%ld",(long)[ScoreComponent shareCurrentScore]] scale:0.65f];
    }
    
    
    return self;
}

//生成菜单目录的label
- (SneakyButton *)makeMeunItemWithLabelName:(NSString *)labelName fontSize:(NSInteger)fontSize heightScale:(CGFloat)scale{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    CCLabelTTF *label = [CCLabelTTF labelWithString:labelName fontName:@"Maker Felt" fontSize:fontSize];
    label.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * scale);
    label.color = [CCColor whiteColor];
    label.horizontalAlignment = CCTextAlignmentCenter;
    [self addChild:label z:2 name:labelName];
    
    SneakyButton *button = [SneakyButton buttonWithRect:CGRectMake(label.position.x, label.position.y, label.contentSize.width, label.contentSize.height)];
    button.isHoldable = YES;
    SneakyButtonSkinnedBase *skinResumeButton = [SneakyButtonSkinnedBase skinnedButton];
    skinResumeButton.position = CGPointMake(label.position.x, label.position.y);
    skinResumeButton.defaultSprite = [CCSprite spriteWithTexture:label.texture];
    skinResumeButton.pressSprite = [CCSprite spriteWithTexture:label.texture];
    skinResumeButton.button = button;
    [self addChild:skinResumeButton];
    return button;
}

//生成结束时分数
- (void)addScoreLabelWithScore:(NSString *)scoreString scale:(CGFloat)scale{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"ArialMT" fontSize:32];
    scoreLabel.color = [CCColor whiteColor];
    scoreLabel.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * scale);
    [self addChild:scoreLabel];
}

-(void)update:(CCTime)delta{
    if (_restartButton.active) {
        [ScoreComponent resetScore];
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    }
    
    if (_settingButton.active) {
        [[CCDirector sharedDirector] pushScene:[GameSettingLayer scene]];
    }
    
    if (_mainButton.active) {
        [[CCDirector sharedDirector] replaceScene:[GameStartLayer scene]];
    }
}

// -----------------------------------------------------------------

@end




















