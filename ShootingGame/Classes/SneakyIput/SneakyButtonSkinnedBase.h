//
//  SneakyButtonSkinnedBase.h
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

@class SneakyButton;

@interface SneakyButtonSkinnedBase : CCSprite {
    CCSprite *defaultSprite;
    CCSprite *activatedSprite;
    CCSprite *disabledSprite;
    CCSprite *pressSprite;
    SneakyButton *button;
}

@property (nonatomic, strong) CCSprite *defaultSprite;
@property (nonatomic, strong) CCSprite *activatedSprite;
@property (nonatomic, strong) CCSprite *disabledSprite;
@property (nonatomic, strong) CCSprite *pressSprite;

@property (nonatomic, strong) SneakyButton *button;

@end




