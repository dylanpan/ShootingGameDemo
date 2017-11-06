//
//  StandardMoveComponent.h
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

typedef NS_ENUM(NSInteger, EnemyPostionTypes){
    EnemyPostionTypeOutsideScreenLeft = 0,
    EnemyPostionTypeOutsideScreenRight,
    EnemyPostionTypeOutsideScreenUp,
    EnemyPostionTypeOutsideScreenDown,
    EnemyPostionTypeOutsideScreenLUCorner,
    EnemyPostionTypeOutsideScreenRUCorner,
    EnemyPostionTypeOutsideScreenLDCorner,
    EnemyPostionTypeOutsideScreenRDCorner,
    EnemyPostionTypeInsideScreen,
};

// -----------------------------------------------------------------

@interface StandardMoveComponent : CCSprite

// -----------------------------------------------------------------
// properties
@property (nonatomic) CGPoint velocity;
@property (nonatomic) NSInteger updateCount;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;
- (BOOL)checkEntity:(CGRect)entityRect intersectsScene:(CGRect)screenRect;
// -----------------------------------------------------------------

@end




