//
//  HealthbarComponent.h
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


typedef NS_ENUM(NSInteger, HealthBarTypes){
    HealthBarTypeShip = 0,
    HealthBarTypeEnemy,
};
// -----------------------------------------------------------------

@interface HealthbarComponent : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic) HealthBarTypes type;
@property (nonatomic, strong) CCSprite *healthbarSprite;
@property (nonatomic, strong) CCSprite *border;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;
- (void)resetWithType:(HealthBarTypes)type;

// -----------------------------------------------------------------

@end




