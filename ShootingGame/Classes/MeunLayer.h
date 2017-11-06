//
//  MeunLayer.h
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/14
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

@interface MeunLayer : CCNode

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) SneakyButton *resumeButton;
@property (nonatomic, strong) SneakyButton *restartButton;
@property (nonatomic, strong) SneakyButton *settingButton;
@property (nonatomic, strong) SneakyButton *mainButton;

// -----------------------------------------------------------------
// methods
+ (id)scene;

// -----------------------------------------------------------------

@end




