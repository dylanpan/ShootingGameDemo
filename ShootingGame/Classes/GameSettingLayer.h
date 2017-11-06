//
//  GameSettingLayer.h
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/30
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface GameSettingLayer : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCSprite *musicButton;
@property (nonatomic, strong) CCSprite *effectButton;
@property (nonatomic, strong) CCSprite *shakeButton;
@property (nonatomic ,strong) CCLabelTTF *backButton;

// -----------------------------------------------------------------
// methods
+ (id)scene;
+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




