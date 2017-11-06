//
//  EnergybarComponent.h
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


typedef NS_ENUM(NSInteger, EnergybarTypes){
    EnergybarTypeShip = 0,
    EnergybarTypeEnemy,
};
// -----------------------------------------------------------------

@interface EnergybarComponent : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic) EnergybarTypes type;
@property (nonatomic, strong) CCSprite *energybarSprite;
@property (nonatomic, strong) CCSprite *border;

// -----------------------------------------------------------------
// methods
- (void)resetEnergybarWithType:(EnergybarTypes)type;
+ (instancetype)node;

// -----------------------------------------------------------------

@end




