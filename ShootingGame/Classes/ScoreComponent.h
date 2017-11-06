//
//  ScoreComponent.h
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

typedef NS_ENUM(NSInteger, ScoreTypes){
    ScoreTypeBuffScore = 1,
    ScoreTypeBreadman = 2,
    ScoreTypeSnake = 4,
    ScoreTypeBoss = 10,
    ScoreType_MAX = 999,
};


// -----------------------------------------------------------------

@interface ScoreComponent : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCLabelTTF *scoreLabel;
@property (nonatomic) NSInteger updateCount;

// -----------------------------------------------------------------
// methods
+ (NSInteger)shareCurrentScore;
+ (NSInteger)shareFlightDistance;
- (void)getScore:(ScoreTypes)type;
+ (NSInteger)getHighScore;
+ (void)storeHighScore;
+ (void)resetScore;
+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




