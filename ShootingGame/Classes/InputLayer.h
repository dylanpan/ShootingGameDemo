//
//  InputLayer.h
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
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButton+Extension.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyButtonSkinnedBase+Extension.h"
#import "SneakyJoystick.h"
#import "SneakyJoystick+Extension.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyJoystickSkinnedBase+Extension.h"


// -----------------------------------------------------------------

@interface InputLayer : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) SneakyButton *fireButton;
@property (nonatomic, strong) SneakyButton *specialButton;
@property (nonatomic, strong) SneakyJoystick *joystick;
@property (nonatomic, strong) SneakyButton *pauseButton;
@property (nonatomic) CCTime totalTime;
@property (nonatomic) CCTime nextShotTime;

// -----------------------------------------------------------------
// methods
+ (instancetype)node;

// -----------------------------------------------------------------

@end




