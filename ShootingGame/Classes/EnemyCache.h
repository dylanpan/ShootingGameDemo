//
//  EnemyCache.h
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

@interface EnemyCache : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) NSMutableArray *enemies;
@property (nonatomic) NSInteger updateCount;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;

// -----------------------------------------------------------------

@end




