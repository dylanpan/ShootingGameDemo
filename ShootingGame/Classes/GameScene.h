//
//  GameScene.h
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
#import "EnemyEntity.h"

@class ShipEntity;
@class BulletCache;

typedef NS_ENUM(NSInteger, GameSceneLayerTags){
    GameSceneLayerTagGame = 1,
    GameSceneLayerTagInput,
};

typedef NS_ENUM(NSInteger, GameSceneNodeTags){
    GameSceneNodeTagBullet = 1,
    GameSceneNodeTagBulletSpriteBatch,
    GameSceneNodeTagBulletCache,
    GameSceneNodeTagEnemyCache,
    GameSceneNodeTagShip,
};

// -----------------------------------------------------------------

@interface GameScene : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic, readonly) BulletCache *bulletCache;
@property (nonatomic, strong) CCSprite *backgroundSpriteAnim;
@property (nonatomic, strong) CCSprite *bossShowupLabel;

// -----------------------------------------------------------------
// methods
+ (id)scene;
+ (GameScene *)shareGameScene;
- (ShipEntity *)defaultShip;
+ (CGRect)screenRect;
- (void)shakeGameSceneWithEnemyType:(EnemyTypes)type;

// -----------------------------------------------------------------

@end




