//
//  Bullet.h
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


typedef NS_ENUM(NSInteger, BulletTypes){
    BulletTypeNormal = 0,
    BulletTypeMissile,
    BulletType_MAX,
};

// -----------------------------------------------------------------

@interface Bullet : CCSprite

// -----------------------------------------------------------------
// properties
@property (nonatomic) CGPoint velocity;
@property (nonatomic, assign) BOOL isPlayerBullet;
@property (nonatomic) BulletTypes type;

// -----------------------------------------------------------------
// methods
+ (id)bullet:(BulletTypes)type;
- (void)shootBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet;
- (void)shootMissileWithFrameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet;

// -----------------------------------------------------------------

@end




