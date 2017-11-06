//
//  GameSettingLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/30
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameSettingLayer.h"
#import "GameStartLayer.h"
#import "CCTextureCache.h"
#import "OALSimpleAudio.h"

// -----------------------------------------------------------------

@implementation GameSettingLayer

// -----------------------------------------------------------------
static BOOL isBackgroundMusicOn;
static BOOL isEffectOn;
static BOOL isShakeOn;

+ (id)scene{
    CCScene *scene = [CCScene node];
    GameSettingLayer *gameSettingLayer = [GameSettingLayer node];
    [scene addChild:gameSettingLayer];
    scene.name = @"GameSettingLayer";
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
        self.userInteractionEnabled = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        isBackgroundMusicOn = [defaults boolForKey:@"isBackgroundMusicOn"];
        isEffectOn = [defaults boolForKey:@"isEffectOn"];
        isShakeOn = [defaults boolForKey:@"isShakeOn"];
        
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        CCNodeColor *backgroundLayer = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:69.0f/255.0f green:137.0f/255.0f blue:148.0f/255.0f] width:screenSize.width height:screenSize.height];
        [self addChild:backgroundLayer];
        
        //设置音效开关
        if (isBackgroundMusicOn) {
            _musicButton = [CCSprite spriteWithImageNamed:@"music.png"];
        }else{
            _musicButton = [CCSprite spriteWithImageNamed:@"music-disable.png"];
        }
        _musicButton.position = CGPointMake(screenSize.width * 0.25f, screenSize.height * 0.5f);
        [self addChild:_musicButton];
        
        //设置音乐开关
        if (isEffectOn) {
            _effectButton = [CCSprite spriteWithImageNamed:@"effect.png"];
        }else{
            _effectButton = [CCSprite spriteWithImageNamed:@"effect-disable.png"];
        }
        _effectButton.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
        [self addChild:_effectButton];
        
        //设置震动开关
        if (isShakeOn) {
            _shakeButton = [CCSprite spriteWithImageNamed:@"shake.png"];
        }else{
            _shakeButton = [CCSprite spriteWithImageNamed:@"shake-disable.png"];
        }
        _shakeButton.position = CGPointMake(screenSize.width * 0.75f, screenSize.height * 0.5f);
        [self addChild:_shakeButton];
        
        //返回按钮
        _backButton = [CCLabelTTF labelWithString:@"BACK" fontName:@"ArailMT" fontSize:16];
        _backButton.position = CGPointMake(screenSize.width - _backButton.contentSize.width * 0.5f - 20.0f, screenSize.height - _backButton.contentSize.height * 0.5f - 20.0f);
        [self addChild:_backButton];
    }
    return self;
}

- (void)backgroundMusicSwitchStore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isBackgroundMusicOn forKey:@"isBackgroundMusicOn"];
    [defaults synchronize];
}

- (void)effectSwitchStore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isEffectOn forKey:@"isEffectOn"];
    [defaults synchronize];
}

- (void)shakeSwitchStore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isShakeOn forKey:@"isShakeOn"];
    [defaults synchronize];
}

- (CGRect)getRect:(CCNode *)sender{
    CGRect rect = CGRectMake(sender.position.x - sender.contentSize.width * 0.5f, sender.position.y - sender.contentSize.height * 0.5f, sender.contentSize.width, sender.contentSize.height);
    return rect;
}

- (void)changeSpriteFrame:(CCSprite *)sprite Name:(NSString *)name{
    sprite.spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
}

#pragma touch methods
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchPos = [touch locationInView:[touch view]];
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:touchPos];
    //NSLog(@"touch pos:%f,%f",touchLocation.x,touchLocation.y);
    CGRect buttonRect = [self getRect:_backButton];
    CGRect musicRect = [self getRect:_musicButton];
    CGRect effectRect = [self getRect:_effectButton];
    CGRect shakeRect = [self getRect:_shakeButton];
    if (CGRectContainsPoint(buttonRect, touchLocation)) {
        //返回跳转之前进来的页面：游戏开始、游戏中、游戏结束
        [[CCDirector sharedDirector] popScene];
    }else if (CGRectContainsPoint(musicRect, touchLocation)) {
        if (isBackgroundMusicOn) {
            [self changeSpriteFrame:_musicButton Name:@"music-disable.png"];
            [[OALSimpleAudio sharedInstance] setBgPaused:YES];
            isBackgroundMusicOn = NO;
            [self backgroundMusicSwitchStore];
        }else{
            [self changeSpriteFrame:_musicButton Name:@"music.png"];
            [[OALSimpleAudio sharedInstance] setBgPaused:NO];
            isBackgroundMusicOn = YES;
            [self backgroundMusicSwitchStore];
        }
    }else if (CGRectContainsPoint(effectRect, touchLocation)) {
        if (isEffectOn) {
            [self changeSpriteFrame:_effectButton Name:@"effect-disable.png"];
            [[OALSimpleAudio sharedInstance] setEffectsPaused:YES];
            isEffectOn = NO;
            [self effectSwitchStore];
        }else{
            [self changeSpriteFrame:_effectButton Name:@"effect.png"];
            [[OALSimpleAudio sharedInstance] setEffectsPaused:NO];
            isEffectOn = YES;
            [self effectSwitchStore];
        }
    }else if (CGRectContainsPoint(shakeRect, touchLocation)) {
        if (isShakeOn) {
            [self changeSpriteFrame:_shakeButton Name:@"shake-disable.png"];
            
            isShakeOn = NO;
            [self shakeSwitchStore];
        }else{
            [self changeSpriteFrame:_shakeButton Name:@"shake.png"];
            
            isShakeOn = YES;
            [self shakeSwitchStore];
        }
    }

    
}


// -----------------------------------------------------------------

@end





















