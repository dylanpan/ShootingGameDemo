//
//  InputLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "InputLayer.h"
#import "GameScene.h"
#import "MeunLayer.h"
#import "ShipEntity.h"
#import "BulletCache.h"
#import "EnergybarComponent.h"

@interface InputLayer(PrivateMethods)
- (void)addFireButton;
- (void)addJoystick;
- (void)addPauseButton;
@end

// -----------------------------------------------------------------

@implementation InputLayer

// -----------------------------------------------------------------
+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        [self addFireButton];
        [self addJoystick];
        [self addPauseButton];
        [self addSpecialButton];
    }
    
    return self;
}

//- (void)dealloc{
//    [super dealloc];
//}

- (void)addFireButton{
    float buttonRadius = 50;
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    
    _fireButton = [SneakyButton button];
    _fireButton.isHoldable = YES;
    
    SneakyButtonSkinnedBase *skinFireButton = [SneakyButtonSkinnedBase skinnedButton];
    skinFireButton.position = CGPointMake(screenSize.width - buttonRadius * 2.0f, buttonRadius * 0.7f);
    skinFireButton.defaultSprite = [CCSprite spriteWithImageNamed:@"button-default1.png"];
    skinFireButton.pressSprite = [CCSprite spriteWithImageNamed:@"button-pressed1.png"];
    skinFireButton.button = _fireButton;
    skinFireButton.scale = 0.5f;
    [self addChild:skinFireButton];
}

- (void)addSpecialButton{
    float buttonRadius = 50;
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    
    _specialButton = [SneakyButton button];
    _specialButton.isHoldable = YES;
    
    SneakyButtonSkinnedBase *skinSpecialButton = [SneakyButtonSkinnedBase skinnedButton];
    skinSpecialButton.position = CGPointMake(screenSize.width - buttonRadius * 0.7f, buttonRadius * 1.5f);
    skinSpecialButton.defaultSprite = [CCSprite spriteWithImageNamed:@"button-default1.png"];
    skinSpecialButton.pressSprite = [CCSprite spriteWithImageNamed:@"button-pressed1.png"];
    skinSpecialButton.button = _specialButton;
    skinSpecialButton.scale = 0.5f;
    [self addChild:skinSpecialButton];
}

- (void)addJoystick{
    float stickRaduis = 50;
    
    _joystick = [SneakyJoystick joystickWithRect:CGRectMake(0.0f, 0.0f, stickRaduis * 2.0f, stickRaduis * 2.0f)];
    _joystick.autoCenter = YES;
    
    _joystick.isDPad = YES;
    _joystick.numberOfDirections = 8;
    
    SneakyJoystickSkinnedBase *skinJoystick = [SneakyJoystickSkinnedBase skinnedJoystick];
    skinJoystick.position = CGPointMake(stickRaduis * 1.5f, stickRaduis * 1.5f);
    skinJoystick.backgroundSprite = [CCSprite spriteWithImageNamed:@"button-disabled1.png"];
    //skinJoystick.backgroundSprite.color = [CCColor magentaColor];
    skinJoystick.thumbSprite = [CCSprite spriteWithImageNamed:@"button-disabled1.png"];
    skinJoystick.thumbSprite.scale = 0.5f;
    skinJoystick.joystick = _joystick;
    [self addChild:skinJoystick];
}

- (void)addPauseButton{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    
    _pauseButton = [SneakyButton buttonWithRect:CGRectMake(0.0f, 0.0f, 16.0f, 16.0f)];
    _pauseButton.isHoldable = YES;
    
    SneakyButtonSkinnedBase *skinPauseButton = [SneakyButtonSkinnedBase skinnedButton];
    skinPauseButton.position = CGPointMake(screenSize.width * 0.5f, screenSize.height - 8.0f);
    skinPauseButton.defaultSprite = [CCSprite spriteWithImageNamed:@"pause.png"];
    skinPauseButton.pressSprite = [CCSprite spriteWithImageNamed:@"pause.png"];
    skinPauseButton.button = _pauseButton;
    [self addChild:skinPauseButton];
}

- (void)update:(CCTime)delta{
    _totalTime += delta;
    
    //继续fire，长摁会在一定时间间隔发射子弹
    if (_fireButton.active && _totalTime > _nextShotTime) {
        _nextShotTime = _totalTime + 0.5f;
        
        GameScene *game = [GameScene shareGameScene];
        ShipEntity *ship = [game defaultShip];
        BulletCache *bulletCahe = [game bulletCache];
        
        CGPoint shotPos = CGPointMake(ship.position.x + [ship contentSize].width * 0.5f, ship.position.y);
        float spread = (CCRANDOM_0_1() - 0.5f) * 0.5f;
        CGPoint velocity = CGPointMake(4.0f, spread);
        [bulletCahe shootBulletFrom:shotPos velocity:velocity frameName:@"bullet.png" isPlayerBullet:YES];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isEffectOn = [defaults boolForKey:@"isEffectOn"];
        if (isEffectOn) {
            [[OALSimpleAudio sharedInstance] playEffect:@"shoot.caf" volume:0.2f pitch:2.0f pan:0.0f loop:NO];
        }
    }
    
    //快速射击，通过连续点击按钮发射子弹
    if (_fireButton.active == NO) {
        _nextShotTime = 0;
    }
    
    //通过joystick移动ship
    GameScene *game = [GameScene shareGameScene];
    ShipEntity *ship = [game defaultShip];
    
    CGPoint velocity = ccpMult(_joystick.velocity, 200);//放大摇杆的移动速度
    if (velocity.x != 0 && velocity.y != 0) {
        ship.position = CGPointMake(ship.position.x + velocity.x * delta, ship.position.y + velocity.y * delta);
    }
    
    if (_pauseButton.active) {
        //弹出目录菜单
        [[CCDirector sharedDirector] pushScene:[MeunLayer scene]];
    }
    
    if (_specialButton.active) {
        ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
        if (ship.energyPoints >= 10) {
            ship.energyPoints -= 10;
            BulletCache *bulletCahe = [[GameScene shareGameScene] bulletCache];
            [bulletCahe shootMissileWithFrameName:@"missile-anim0.png" isPlayerBullet:YES];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL isEffectOn = [defaults boolForKey:@"isEffectOn"];
            if (isEffectOn) {
                [[OALSimpleAudio sharedInstance] playEffect:@"missile.caf" volume:1.0f pitch:2.0f pan:0.0f loop:NO];
            }
        }
    }
    
}

// -----------------------------------------------------------------

@end


























