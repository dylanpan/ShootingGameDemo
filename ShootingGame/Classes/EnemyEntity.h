//
//  EnemyEntity.h
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


typedef NS_ENUM(NSInteger, EnemyTypes){
    EnemyTypeBreadman = 0,
    EnemytypeSnake,
    EnemyTypeBoss,
    EnemyType_MAX,
};

// -----------------------------------------------------------------

@interface EnemyEntity : Entity

// -----------------------------------------------------------------
// properties
@property (nonatomic, readonly) NSInteger initialHitPoints;
@property (nonatomic, readonly) NSInteger hitPoints;
@property (nonatomic, readonly) CGFloat initialShieldPoints;
@property (nonatomic) CGFloat shieldPoints;
@property (nonatomic, readonly) CGFloat initialEnergyPoints;
@property (nonatomic) CGFloat energyPoints;
@property (nonatomic) EnemyTypes type;
@property (nonatomic, strong) id<ALSoundSource> bossComingEffect;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;
+ (id)enemyWithType:(EnemyTypes)enemyType;
+ (NSInteger)getSpawnFrequencyForEnemyType:(EnemyTypes)enemyType;
- (void)spawn;
- (void)gotHit;

// -----------------------------------------------------------------

@end




