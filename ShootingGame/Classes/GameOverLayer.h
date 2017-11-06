//
//  GameOverLayer.h
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
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButton+Extension.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyButtonSkinnedBase+Extension.h"

// -----------------------------------------------------------------

@interface GameOverLayer : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) SneakyButton *restartButton;
@property (nonatomic, strong) SneakyButton *settingButton;
@property (nonatomic, strong) SneakyButton *mainButton;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
+ (id)scene;

// -----------------------------------------------------------------

@end




