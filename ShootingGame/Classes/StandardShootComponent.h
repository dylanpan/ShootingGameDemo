//
//  StandardShootComponent.h
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

@interface StandardShootComponent : CCSprite

// -----------------------------------------------------------------
// properties
@property (nonatomic) NSInteger updateCount;
@property (nonatomic) NSInteger shootFrequency;
@property (nonatomic, copy) NSString *bulletFrameName;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;

// -----------------------------------------------------------------

@end




