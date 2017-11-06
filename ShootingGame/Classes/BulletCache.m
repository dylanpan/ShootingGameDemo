//
//  BulletCache.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "BulletCache.h"
#import "Bullet.h"

#define PresetBulletNumber 200
#define PresetMissileNumber 10

@interface BulletCache(PrivateMethods)
- (BOOL)isBulletCollidingWithRect:(CGRect)rect usePlayerBullets:(BOOL)usePlayerBullets;
@end
// -----------------------------------------------------------------

@implementation BulletCache

// -----------------------------------------------------------------
+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        //从纹理集中获取bullet的图片
        //CCSpriteFrame *bulletFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bullet.png"];
        
        //添加纹理集到batch node中，3.1版本之后不需要在先放置在batch node中先行进行渲染，直接放置各自的texture，注意z-value的先后
        //_batch = [CCSpriteBatchNode batchNodeWithTexture:bulletFrame.texture];
        //[self addChild:_batch];
        
        //预先生成一定数量的子弹
        for (NSInteger i = 0; i < PresetBulletNumber; i++) {
            Bullet *bullet = [Bullet bullet:BulletTypeNormal];
            bullet.visible = NO;
            [self addChild:bullet z:0 name:@"BulletTypeNormal"];
        }
        for (NSInteger i = 0; i < PresetMissileNumber; i++) {
            Bullet *bullet = [Bullet bullet:BulletTypeMissile];
            bullet.visible = NO;
            [self addChild:bullet z:0 name:@"BulletTypeMissile"];
        }
    }
    
    return self;
}

//发射普通子弹
- (void)shootBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet{
    NSArray *bullets = [self children];
    NSMutableArray *normalBullets = [[NSMutableArray alloc] init];
    for (CCNode *node in bullets) {
        NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet class");
        Bullet *bullet = (Bullet *)node;
        if (bullet.type == BulletTypeNormal) {
            [normalBullets addObject:bullet];
        }
    }
    CCNode *node = [normalBullets objectAtIndex:_nextInactiveBullet];
    Bullet *bullet = (Bullet *)node;
    if (bullet.type == BulletTypeNormal) {
        [bullet shootBulletAt:startPosition velocity:velocity frameName:frameName isPlayerBullet:isPlayerBullet];
    }
    
    _nextInactiveBullet++;
    if (_nextInactiveBullet >= ([bullets count] - PresetMissileNumber)) {
        _nextInactiveBullet = 0;
    }
}

//发射特殊技能子弹
- (void)shootMissileWithFrameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet{
    NSArray *bullets = [self children];
    NSMutableArray *missileBullets = [[NSMutableArray alloc] init];
    for (CCNode *node in bullets) {
        NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet class");
        Bullet *bullet = (Bullet *)node;
        if (bullet.type == BulletTypeMissile) {
            [missileBullets addObject:bullet];
        }
    }
    CCNode *node = [missileBullets objectAtIndex:_nextInactiveMissile];
    Bullet *bullet = (Bullet *)node;
    if (bullet.type == BulletTypeMissile) {
        [bullet shootMissileWithFrameName:frameName isPlayerBullet:isPlayerBullet];
    }
    
    _nextInactiveMissile++;
    if (_nextInactiveMissile >= ([bullets count] - PresetBulletNumber)) {
        _nextInactiveMissile = 0;
    }
}

- (BOOL)isPlayerBulletCollidingWithRect:(CGRect)rect{
    return [self isBulletCollidingWithRect:rect usePlayerBullets:YES];
}

- (BOOL)isEnemyBulletCollidingWithRect:(CGRect)rect{
    return [self isBulletCollidingWithRect:rect usePlayerBullets:NO];
}

- (BOOL)isBulletCollidingWithRect:(CGRect)rect usePlayerBullets:(BOOL)usePlayerBullets{
    BOOL isColliding = NO;
    
    NSArray *bullets = [self children];
    for (Bullet *bullet in bullets) {
        BOOL isPlayerBullet = bullet.isPlayerBullet;
        if (bullet.type == BulletTypeNormal) {
            if (bullet.visible && usePlayerBullets == isPlayerBullet) {
                if (CGRectIntersectsRect([bullet boundingBox], rect)) {
                    isColliding = YES;
                    bullet.visible = NO;
                    break;
                }
            }
        }else if (bullet.type == BulletTypeMissile) {
            if (bullet.visible && usePlayerBullets == isPlayerBullet) {
                if (CGRectIntersectsRect([bullet boundingBox], rect)) {
                    isColliding = YES;
                    bullet.visible = YES;
                    break;
                }
            }
        }
    }
    return isColliding;
}
// -----------------------------------------------------------------

@end





