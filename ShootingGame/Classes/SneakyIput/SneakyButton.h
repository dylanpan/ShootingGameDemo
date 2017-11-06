//
//  SneakyButton.h
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

@interface SneakyButton : CCNode {
    CGPoint center;
    
    float radius;
    float radiusSq;
    
    CGRect bounds;
    BOOL active;
    BOOL status;
    BOOL value;
    BOOL isHoldable;
    BOOL isToggleable;
    float rateLimit;
}

@property (nonatomic, assign) BOOL status;
@property (nonatomic, readonly) BOOL value;
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, assign) BOOL isHoldable;
@property (nonatomic, assign) BOOL isToggleable;
@property (nonatomic, assign) float rateLimit;

//Optimizations (keep Squared values of all radii for faster calculations) (updated internally when changing radii)
@property (nonatomic, assign) float radius;

-(id)initWithRect:(CGRect)rect;

@end




