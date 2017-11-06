//
//  ParallaxBackground.h
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

@interface ParallaxBackground : CCNode

// -----------------------------------------------------------------
// properties
//@property (nonatomic, strong) CCSprite *spriteBatch;
@property (nonatomic) NSInteger numStripes;
//@property (nonatomic, retain) NSMutableArray *speedFactors;
@property (nonatomic, strong) NSMutableArray *speedFactors;
@property (nonatomic) float scrollSpeed;
@property (nonatomic) CGSize screenSize;
// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




