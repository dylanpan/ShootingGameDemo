//
//  GameStartLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/30
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameStartLayer.h"
#import "GameScene.h"
#import "GameSettingLayer.h"
#import "GameCreditsLayer.h"
#import "OALSimpleAudio.h"

// -----------------------------------------------------------------

@implementation GameStartLayer

// -----------------------------------------------------------------
+ (id)scene{
    CCScene *scene = [CCScene node];
    GameStartLayer *gameStartLayer = [GameStartLayer node];
    [scene addChild:gameStartLayer];
    scene.name = @"GameStartLayer";
    return scene;
}

- (id)init{
    self = [super init];
    if (self) {
        //添加所有的图片纹理集对应的plist文件
        _frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [_frameCache addSpriteFramesWithFile:@"game-art.plist"];
        
        _screenSize = [[CCDirector sharedDirector] viewSize];
        //添加背景动画
        NSMutableArray *gameStartBackgroundArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 8; i++) {
            NSString *gameStartString = [NSString stringWithFormat:@"start-anim%ld.png",(long)i];
            CCSpriteFrame *gameStartSpriteFrame = [_frameCache spriteFrameByName:gameStartString];
            [gameStartBackgroundArray addObject:gameStartSpriteFrame];
        }
        _gameStartBackgroundSprite = [CCSprite spriteWithImageNamed:@"start-anim0.png"];
        _gameStartBackgroundSprite.position = CGPointMake(0.0f, 0.0f);
        _gameStartBackgroundSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
        [self addChild:_gameStartBackgroundSprite z:-1 name:@"GameStartLayerBackgroundSpriteNode"];
        
        _gameStartBackgroundSpriteEnd = [CCSprite spriteWithImageNamed:@"start-anim7.png"];
        _gameStartBackgroundSpriteEnd.position = CGPointMake(_screenSize.width - 1, 0.0f);
        _gameStartBackgroundSpriteEnd.anchorPoint = CGPointMake(0.0f, 0.0f);
        _gameStartBackgroundSpriteEnd.flipX = YES;
        CCAnimation *gameStartAnimation = [CCAnimation animationWithSpriteFrames:gameStartBackgroundArray delay:0.1f];
        CCActionAnimate *gameStartAnimAction = [CCActionAnimate actionWithAnimation:gameStartAnimation];
        CCActionCallFunc *gameStartActionDone = [CCActionCallFunc actionWithTarget:self selector:@selector(gameStartAnimActionDone)];
        [_gameStartBackgroundSprite runAction:[CCActionSequence actions:gameStartAnimAction, gameStartActionDone, nil]];
        
        //添加按钮
        self.userInteractionEnabled = YES;
        _gameStartButton = [self addGameStartButtonWithName:@"New Game" positionY:_screenSize.height * 0.6f fontSize:32];
        _gameSettingButton = [self addGameStartButtonWithName:@"Setting" positionY:_screenSize.height * 0.45f fontSize:20];
        _gameCreditsButton = [self addGameStartButtonWithName:@"Credits" positionY:_screenSize.height * 0.35f fontSize:20];
        
        //添加背景音乐
        BOOL *isBackgroundMusicOn = [[OALSimpleAudio sharedInstance] playBg:@"ShootingStarOfField.mp3" loop:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:isBackgroundMusicOn forKey:@"isBackgroundMusicOn"];
        [defaults setBool:@(YES) forKey:@"isEffectOn"];
        [defaults setBool:@(YES) forKey:@"isShakeOn"];
        [defaults synchronize];
    }
    return self;
}

- (void)gameStartAnimActionDone{
    _gameStartBackgroundSprite = [CCSprite spriteWithImageNamed:@"start-anim7.png"];
    NSMutableArray *gameStartPlaneArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        NSString *gameStartString = [NSString stringWithFormat:@"ship-biplane-anim%ld.png",(long)i];
        CCSpriteFrame *gameStartSpriteFrame = [_frameCache spriteFrameByName:gameStartString];
        [gameStartPlaneArray addObject:gameStartSpriteFrame];
    }
    _gameStartPlaneSprite = [CCSprite spriteWithImageNamed:@"ship-biplane.png"];
    _gameStartPlaneSprite.position = CGPointMake(0.0f, _screenSize.height * 0.4f);
    _gameStartPlaneSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:_gameStartPlaneSprite z:-1 name:@"GameStartLayerPlaneSpriteNode"];
    
    CCAnimation *gameStartPlaneAnimation = [CCAnimation animationWithSpriteFrames:gameStartPlaneArray delay:0.1f];
    CCActionAnimate *gameStartPlaneAnimAction = [CCActionAnimate actionWithAnimation:gameStartPlaneAnimation];
    CCActionRepeatForever *gameStartPlaneAnimActionRepeat = [CCActionRepeatForever actionWithAction:gameStartPlaneAnimAction];
    CCActionMoveTo *gameStartPlaneMoveAction = [CCActionMoveTo actionWithDuration:2.5f position:CGPointMake(_screenSize.width, _screenSize.height * 0.5f)];
    CCActionCallFunc *gameStartActionAllDone = [CCActionCallFunc actionWithTarget:self selector:@selector(parallaxGameStartBackground)];
    [_gameStartPlaneSprite runAction:gameStartPlaneAnimActionRepeat];
    [_gameStartPlaneSprite runAction:[CCActionSequence actions:gameStartPlaneMoveAction, gameStartActionAllDone, nil]];
}

- (void)parallaxGameStartBackground{
    
}

- (CCLabelTTF *)addGameStartButtonWithName:(NSString *)buttonName positionY:(CGFloat)posY fontSize:(NSInteger)fontSize{
    CCLabelTTF *labelButton = [CCLabelTTF labelWithString:buttonName fontName:@"ArialMT" fontSize:fontSize];
    labelButton.position = CGPointMake(-labelButton.contentSize.width * 0.5f, posY);
    labelButton.color = [CCColor whiteColor];
    [self addChild:labelButton z:0];
    return labelButton;
}

- (CCActionMoveTo *)addMoveActionToButtonWithDuration:(CGFloat)duration PositionY:(CGFloat)posY{
    CCActionMoveTo *buttonMoveAction = [CCActionMoveTo actionWithDuration:duration position:CGPointMake(_screenSize.width * 0.5f,posY)];
    return buttonMoveAction;
}

- (CGRect)getLabelRect:(CCLabelTTF *)label{
    CGRect labelRect = CGRectMake(label.position.x - label.contentSize.width * 0.5f, label.position.y - label.contentSize.height * 0.5f, label.contentSize.width, label.contentSize.height);
    return labelRect;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchPos = [touch locationInView:[touch view]];
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:touchPos];
    //NSLog(@"touch pos:%f,%f",touchLocation.x,touchLocation.y);
    CGRect gameStartLabelRect = [self getLabelRect:_gameStartButton];
    CGRect gameSettingLabelRect = [self getLabelRect:_gameSettingButton];
    CGRect gameCreditsLabelRect = [self getLabelRect:_gameCreditsButton];
    //NSLog(@"gameStartLabelRect:%f,%f,%f,%f",gameStartLabelRect.origin.x,gameStartLabelRect.origin.y,gameStartLabelRect.size.width,gameStartLabelRect.size.height);
    if (CGRectContainsPoint(gameStartLabelRect, touchLocation)) {
        //跳转到GameScene
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    }else if (CGRectContainsPoint(gameSettingLabelRect, touchLocation)) {
        //跳转到SettingScene
        [[CCDirector sharedDirector] pushScene:[GameSettingLayer scene]];
    }else if (CGRectContainsPoint(gameCreditsLabelRect, touchLocation)) {
        //跳转到CreditsScene
        [[CCDirector sharedDirector] pushScene:[GameCreditsLayer scene]];
    }
}

- (void)update:(CCTime)delta{
    NSInteger planePosX = (NSInteger)_gameStartPlaneSprite.position.x;
    NSInteger actionPosX = (NSInteger)_screenSize.width * 0.2f;
    if (planePosX == actionPosX) {
        //button添加action
        [_gameStartButton runAction:[self addMoveActionToButtonWithDuration:0.8f PositionY:_gameStartButton.position.y]];
        [_gameSettingButton runAction:[self addMoveActionToButtonWithDuration:1.0f PositionY:_gameSettingButton.position.y]];
        [_gameCreditsButton runAction:[self addMoveActionToButtonWithDuration:1.2f PositionY:_gameCreditsButton.position.y]];
    }
}

// -----------------------------------------------------------------

@end





