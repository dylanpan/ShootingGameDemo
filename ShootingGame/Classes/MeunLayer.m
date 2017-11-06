//
//  MeunLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/14
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "MeunLayer.h"
#import "GameScene.h"
#import "GameStartLayer.h"
#import "GameSettingLayer.h"
#import "ScoreComponent.h"

@interface MeunLayer(PrivateMethods)
- (SneakyButton *)makeMeunItemWithLabelName:(NSString *)labelName fontSize:(NSInteger)fontSize heightScale:(CGFloat)scale;
@end
// -----------------------------------------------------------------

@implementation MeunLayer

// -----------------------------------------------------------------
+ (id)scene{
    CCScene *scene = [CCScene node];
    MeunLayer *meunLayer = [MeunLayer node];
    [scene addChild:meunLayer z:0 name:@"GameSceneLayerTagPauseMeun"];
    scene.name = @"GamePauseLayer";
    return scene;
}

+ (id)node{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        //获取当前游戏截图用生成暂停层的背景
        CCRenderTexture *renderTexture = [CCRenderTexture renderTextureWithWidth:[GameScene screenRect].size.width height:[GameScene screenRect].size.height];
        [renderTexture begin];
        [[GameScene shareGameScene] visit];
        [renderTexture end];
        
        CCSprite *meunBackground = [CCSprite spriteWithTexture:renderTexture.texture];
        meunBackground.position = CGPointMake([GameScene screenRect].size.width * 0.5f, [GameScene screenRect].size.height * 0.5f);
        meunBackground.color = [CCColor grayColor];
        [self addChild:meunBackground z:1 name:@"meunBackground"];
        
        //生成目录项目：继续（resume）、重新开始（restart）、游戏设置（setting）、返回主页（main）
        _resumeButton = [self makeMeunItemWithLabelName:@"Resume" fontSize:32 heightScale:0.8f];
        _restartButton = [self makeMeunItemWithLabelName:@"Restart" fontSize:16 heightScale:0.6f];
        _settingButton = [self makeMeunItemWithLabelName:@"Setting" fontSize:16 heightScale:0.4f];
        _mainButton = [self makeMeunItemWithLabelName:@"Main" fontSize:16 heightScale:0.2f];
    }
    
    return self;
}

//生成菜单目录的label
- (SneakyButton *)makeMeunItemWithLabelName:(NSString *)labelName fontSize:(NSInteger)fontSize heightScale:(CGFloat)scale{
    CCLabelTTF *label = [CCLabelTTF labelWithString:labelName fontName:@"Maker Felt" fontSize:fontSize];
    label.position = CGPointMake([GameScene screenRect].size.width * 0.5f, [GameScene screenRect].size.height * scale);
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

-(void)update:(CCTime)delta{
    if (_resumeButton.active) {
        [[CCDirector sharedDirector] popScene];
    }
    
    if (_restartButton.active) {
        [ScoreComponent resetScore];
        [[CCDirector sharedDirector] popScene];
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    }
    
    if (_settingButton.active) {
        [[CCDirector sharedDirector] pushScene:[GameSettingLayer scene]];
    }
    
    if (_mainButton.active) {
        [[CCDirector sharedDirector] popScene];
        [[CCDirector sharedDirector] replaceScene:[GameStartLayer scene]];
    }
}
// -----------------------------------------------------------------


@end





