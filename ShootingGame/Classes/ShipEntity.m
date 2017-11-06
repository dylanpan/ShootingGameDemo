//
//  ShipEntity.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "ShipEntity.h"
#import "GameScene.h"
#import "GameContinueLayer.h"
#import "CCAnimation+Helper.h"
#import "checkDeviceConfig.h"
#import "HealthbarComponent.h"
#import "ScoreComponent.h"
#import "ShieldbarComponent.h"
#import "EnergybarComponent.h"

@interface ShipEntity(PrivateMethods)
- (id)initWithShipImage;
@end
// -----------------------------------------------------------------

@implementation ShipEntity

// -----------------------------------------------------------------
+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

+ (id)ship{
    //return [[[self alloc] initWithShipImage] autorelease];
    return [[self alloc] initWithShipImage];
}

- (id)initWithShipImage{
    NSString *shipName = [NSString stringWithFormat:@"ship-biplane"];
//    NSString *iphoneVersion = [checkDeviceConfig deviceVersionInSimulator];
//    if ([iphoneVersion isEqualToString:@"iPhone 5"]) {
//        shipName = [NSString stringWithFormat:@"ship-default"];
//    }else if ([iphoneVersion isEqualToString:@"iPhone 5s"]){
//        shipName = [NSString stringWithFormat:@"ship-default"];
//    }else if ([iphoneVersion isEqualToString:@"iPhone 5c"]){
//        shipName = [NSString stringWithFormat:@"ship-default"];
//    }else if ([iphoneVersion isEqualToString:@"iPhone 6"]){
//        shipName = [NSString stringWithFormat:@"ship-biplane"];
//    }else if ([iphoneVersion isEqualToString:@"iPhone 7"]){
//        shipName = [NSString stringWithFormat:@"ship-biplane"];
//    }else if ([iphoneVersion isEqualToString:@"iPhone 6 Plus"]){
//        shipName = [NSString stringWithFormat:@"ship-jet"];
//    }else if ([iphoneVersion isEqualToString:@"iPhone 7 Plus"]){
//        shipName = [NSString stringWithFormat:@"ship-jet"];
//    }
    
    if (self = [super initWithImageNamed:[NSString stringWithFormat:@"%@.png",shipName]]) {
        CCAnimation *animation = [CCAnimation animationWithFrame:[NSString stringWithFormat:@"%@-anim",shipName] frameCount:5 delay:0.08f];
        
        CCActionAnimate *animate = [CCActionAnimate actionWithAnimation:animation];
        CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:animate];
        [self runAction:repeat];
        
        _initialHitPoints = 20;
        _hitPoints = 20;
        _initialShieldPoints = 20.0f;
        _shieldPoints = 20.0f;
        _initialEnergyPoints = 20;
        _energyPoints = 0;
        
        HealthbarComponent *healthBar = [HealthbarComponent node];
        healthBar.type = HealthBarTypeShip;
        [[GameScene shareGameScene] addChild:healthBar];
        [healthBar resetWithType:HealthBarTypeShip];
        
        ShieldbarComponent *shieldBar = [ShieldbarComponent node];
        shieldBar.type = ShieldbarTypeShip;
        [[GameScene shareGameScene] addChild:shieldBar];
        [shieldBar resetShieldbarWithType:ShieldbarTypeShip];
        
        EnergybarComponent *energyBar = [EnergybarComponent node];
        energyBar.type = EnergybarTypeShip;
        [[GameScene shareGameScene] addChild:energyBar];
        [energyBar resetEnergybarWithType:EnergybarTypeShip];
    }
    return self;
}

//重写setPosition方法
- (void)setPosition:(CGPoint)position{
    //如果现在的位置在屏幕外，不用调整；允许entity从屏幕外进入屏幕内
    if (CGRectContainsRect([GameScene screenRect], [self boundingBox])) {
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        float halfWidth = self.contentSize.width * 0.5f;
        float halfHeight = self.contentSize.height * 0.5f;
        
        if (position.x < halfWidth) {
            position.x = halfWidth;
        }else if (position.x > (screenSize.width - halfWidth)){
            position.x = screenSize.width - halfWidth;
        }
        
        if (position.y < halfHeight) {
            position.y = halfHeight;
        }else if (position.y > (screenSize.height - halfHeight)){
            position.y = screenSize.height - halfHeight;
        }
    }
    [super setPosition:position];
}

- (void)gotHit{
    if (_shieldPoints > 0.0f) {
        _shieldPoints--;
    }else if (_shieldPoints <= 0.0f) {
        _hitPoints--;
    }
    
    [ShieldbarComponent checkShipIsUnderAttack:YES];
    
    if (_hitPoints <= 0) {
        self.visible = NO;
        
        //添加结算页面，判断是否保存最高分
        [ScoreComponent storeHighScore];
        [[CCDirector sharedDirector] pushScene:[GameContinueLayer scene]];
    }
}

// -----------------------------------------------------------------

@end




