//
//  GameStartLayer.h
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

@interface GameStartLayer : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCSpriteFrameCache *frameCache;
@property (nonatomic, strong) CCSprite *gameStartBackgroundSprite;
@property (nonatomic, strong) CCSprite *gameStartBackgroundSpriteEnd;
@property (nonatomic, strong) CCSprite *gameStartPlaneSprite;
@property (nonatomic, strong) CCLabelTTF *gameStartButton;
@property (nonatomic, strong) CCLabelTTF *gameSettingButton;
@property (nonatomic, strong) CCLabelTTF *gameCreditsButton;
@property (nonatomic) CGSize screenSize;

// -----------------------------------------------------------------
// methods
+ (id)scene;

// -----------------------------------------------------------------

@end




