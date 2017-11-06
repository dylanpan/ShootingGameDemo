//
//  StandardShootComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "StandardShootComponent.h"
#import "BulletCache.h"
#import "GameScene.h"

// -----------------------------------------------------------------

@implementation StandardShootComponent

// -----------------------------------------------------------------
+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        //[self schedule:@selector(update:) interval:1.0/60.0f];
    }
    
    return self;
}

//- (void)dealloc{
//    [_bulletFrameName release];
//    [super dealloc];
//}

- (void)update:(CCTime)delta{
    if (self.parent.visible) {
        _updateCount++;
        if (_updateCount >= _shootFrequency) {
            _updateCount = 0;
            
            GameScene *game = [GameScene shareGameScene];
            CGPoint startPos = ccpSub(self.parent.position, CGPointMake(self.parent.contentSize.width * 0.5f, 0.0f));
            [game.bulletCache shootBulletFrom:startPos velocity:CGPointMake(-2.0f, 0.0f) frameName:_bulletFrameName isPlayerBullet:NO];
        }
    }
}

// -----------------------------------------------------------------

@end





