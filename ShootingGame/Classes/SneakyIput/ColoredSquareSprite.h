//
//  ColoredSquareSprite.h
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

@interface ColoredSquareSprite : CCDrawNode  {
    CGSize        size_;
    float        opacity_;
    CCColor     *color_;
    
    CGPoint        *squareVertices_;
    
    ccBlendFunc    blendFunc_;
}

@property (nonatomic,readwrite) CGSize size;

/** creates a Square with color and size */
+ (id) squareWithColor: (ccColor4B)color size:(CGSize)sz;

/** initializes a Circle with color and radius */
- (id) initWithColor:(ccColor4B)color size:(CGSize)sz;

- (BOOL) containsPoint:(CGPoint)point;

@end




