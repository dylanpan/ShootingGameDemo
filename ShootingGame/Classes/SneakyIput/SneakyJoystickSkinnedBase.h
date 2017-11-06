//
//  SneakyJoystickSkinnedBase.h
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

@class SneakyJoystick;

@interface SneakyJoystickSkinnedBase : CCSprite {
    CCSprite *backgroundSprite;
    CCSprite *thumbSprite;
    SneakyJoystick *joystick;
}

@property (nonatomic, strong) CCSprite *backgroundSprite;
@property (nonatomic, strong) CCSprite *thumbSprite;
@property (nonatomic, strong) SneakyJoystick *joystick;

- (void) updatePositions;

@end





