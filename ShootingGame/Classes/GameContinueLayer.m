//
//  GameContinueLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/11/2
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameContinueLayer.h"
#import "GameOverLayer.h"
#import "GameScene.h"
#import "ShipEntity.h"

// -----------------------------------------------------------------

@implementation GameContinueLayer

// -----------------------------------------------------------------
+ (id)scene{
    CCScene *scene = [CCScene node];
    GameContinueLayer *gameContinueLayer = [GameContinueLayer node];
    [scene addChild:gameContinueLayer];
    scene.name = @"GameContinueLayer";
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
        //获取当前游戏截图用生成暂停层的背景
        CCRenderTexture *renderTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
        [renderTexture begin];
        [[GameScene shareGameScene] visit];
        [renderTexture end];
        
        CCSprite *background = [CCSprite spriteWithTexture:renderTexture.texture];
        background.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
        background.color = [CCColor grayColor];
        [self addChild:background z:-1 name:@"GameContinueLayerBackground"];
        
        //单独调试背景
//        CCNodeColor *backgroundLayer = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:69.0f/255.0f green:137.0f/255.0f blue:148.0f/255.0f] width:screenSize.width height:screenSize.height];
//        [self addChild:backgroundLayer];
        
        self.userInteractionEnabled = YES;
        
        _countDown = 10;
        _countDownLabel = [self addButtonWithName:[NSString stringWithFormat:@"%ld",(long)_countDown] position:CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.6f) fontSize:34];
        CCLabelTTF *continueLabel = [self addButtonWithName:@"CONTINUE ?" position:CGPointMake(screenSize.width * 0.37f, screenSize.height * 0.45f) fontSize:20];
        _confirmButton = [self addButtonWithName:@"YES" position:CGPointMake(screenSize.width * 0.57f, screenSize.height * 0.45f) fontSize:20];
        CCLabelTTF *blankLabel = [self addButtonWithName:@" / " position:CGPointMake(screenSize.width * 0.62f, screenSize.height * 0.45f) fontSize:20];
        _cancelButton = [self addButtonWithName:@"NO" position:CGPointMake(screenSize.width * 0.67f, screenSize.height * 0.45f) fontSize:14];
        
    }
    
    
    return self;
}

- (CCLabelTTF *)addButtonWithName:(NSString *)buttonName position:(CGPoint)pos fontSize:(NSInteger)fontSize{
    CCLabelTTF *button = [CCLabelTTF labelWithString:buttonName fontName:@"ArailMT" fontSize:fontSize];
    button.position = pos;
    [self addChild:button z:0];
    return button;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchPos = [touch locationInView:[touch view]];
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:touchPos];
    //NSLog(@"touch pos:%f,%f",touchLocation.x,touchLocation.y);
    CGRect confirmRect = CGRectMake(_confirmButton.position.x - _confirmButton.contentSize.width * 0.5f, _confirmButton.position.y - _confirmButton.contentSize.height * 0.5f, _confirmButton.contentSize.width, _confirmButton.contentSize.height);
    CGRect cancelRect = CGRectMake(_cancelButton.position.x - _cancelButton.contentSize.width * 0.5f, _cancelButton.position.y - _cancelButton.contentSize.height * 0.5f, _cancelButton.contentSize.width, _cancelButton.contentSize.height);
    if (CGRectContainsPoint(confirmRect, touchLocation)) {
        //重置血条
        ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
        ship.hitPoints = ship.initialHitPoints;
        ship.visible = YES;
        _updateCount = 0;
        //返回game scene
        [[CCDirector sharedDirector] popScene];
    }else if (CGRectContainsPoint(cancelRect, touchLocation)) {
        _updateCount = 0;
        //进入game over layer
        [[CCDirector sharedDirector] popScene];
        [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
    }
}

- (void)update:(CCTime)delta{
    _updateCount++;
    if (_updateCount % 60 == 0) {
        _countDown--;
        _countDownLabel.string = [NSString stringWithFormat:@"%ld",(long)_countDown];
    }else if (_countDown == 0) {
        //进入game over layer
        [[CCDirector sharedDirector] popScene];
        [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
    }
}

// -----------------------------------------------------------------

@end





