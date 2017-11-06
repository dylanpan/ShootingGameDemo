//
//  ShieldbarComponent.h
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/31
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef NS_ENUM(NSInteger, ShieldbarTypes){
    ShieldbarTypeShip = 0,
    ShieldbarTypeEnemy,
};
// -----------------------------------------------------------------

@interface ShieldbarComponent : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic) BOOL isAttack;
@property (nonatomic) ShieldbarTypes type;
@property (nonatomic, strong) CCSprite *shieldbarSprite;
@property (nonatomic, strong) CCSprite *border;
@property (nonatomic) NSInteger updateCount;

// -----------------------------------------------------------------
// methods
- (void)resetShieldbarWithType:(ShieldbarTypes)type;
+ (void)checkShipIsUnderAttack:(BOOL)isAttack;
+ (void)checkEnemyIsUnderAttack:(BOOL)isAttack;
+ (instancetype)node;

// -----------------------------------------------------------------

@end




