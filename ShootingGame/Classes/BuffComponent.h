//
//  BuffComponent.h
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/15
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef NS_ENUM(NSInteger, BuffTypes){
    BuffTypeScore = 0,
    BuffTypeAttack,
    BuffTypeDefence,
    BuffTypeSpeed,
};
// -----------------------------------------------------------------

@interface BuffComponent : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCSprite* buffSprite;
@property (nonatomic) BuffTypes type;

// -----------------------------------------------------------------
// methods
- (void)spawnBuffWithPosition:(CGPoint)pos;
+ (id)buffWithType:(BuffTypes)type;
- (void)setBuffSpritePosition:(CGPoint)position;

// -----------------------------------------------------------------

@end




