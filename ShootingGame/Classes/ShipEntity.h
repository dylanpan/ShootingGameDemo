//
//  ShipEntity.h
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Entity.h"

// -----------------------------------------------------------------

@interface ShipEntity : Entity

// -----------------------------------------------------------------
// properties
@property (nonatomic, readonly) NSInteger initialHitPoints;
@property (nonatomic) NSInteger hitPoints;
@property (nonatomic, readonly) CGFloat initialShieldPoints;
@property (nonatomic) CGFloat shieldPoints;
@property (nonatomic, readonly) NSInteger initialEnergyPoints;
@property (nonatomic) NSInteger energyPoints;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;
+ (id)ship;
- (void)gotHit;
// -----------------------------------------------------------------

@end




