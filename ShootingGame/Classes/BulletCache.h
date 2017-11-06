//
//  BulletCache.h
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

// -----------------------------------------------------------------

@interface BulletCache : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic) NSInteger nextInactiveBullet;
@property (nonatomic) NSInteger nextInactiveMissile;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;
- (void)shootBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet;
- (void)shootMissileWithFrameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet;
- (BOOL)isPlayerBulletCollidingWithRect:(CGRect)rect;
- (BOOL)isEnemyBulletCollidingWithRect:(CGRect)rect;

// -----------------------------------------------------------------

@end




