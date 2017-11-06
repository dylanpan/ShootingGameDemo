//
//  GameContinueLayer.h
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/11/2
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface GameContinueLayer : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCLabelTTF *countDownLabel;
@property (nonatomic, strong) CCLabelTTF *confirmButton;
@property (nonatomic, strong) CCLabelTTF *cancelButton;
@property (nonatomic) NSInteger countDown;
@property (nonatomic) NSInteger updateCount;

// -----------------------------------------------------------------
// methods
+ (id)scene;
+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




