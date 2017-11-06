//
//  Bullet.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Bullet.h"
#import "GameScene.h"
#import "ShipEntity.h"
#import "CCAnimation+Helper.h"

@interface Bullet(PrivateMethods)
- (id)initWithBulletImage;
@end

// -----------------------------------------------------------------

@implementation Bullet

// -----------------------------------------------------------------
+ (id)bullet:(BulletTypes)type{
    return [[self alloc] initWithBulletImageWithType:type];
}

- (id)initWithBulletImageWithType:(BulletTypes)type{
    _type = type;
    switch (_type) {
        case BulletTypeNormal:
            self = [super initWithImageNamed:@"bullet.png"];
            break;
            
        case BulletTypeMissile:
            self = [super initWithImageNamed:@"missile-anim0.png"];
            break;
            
        default:
            [NSException exceptionWithName:@"Bullet Exception" reason:@"unhandled bullet type" userInfo:nil];
            break;
    }
    return self;
}

- (void)shootBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet{
    self.velocity = vel;//后续可修改成被buff影响
    self.position = startPosition;
    self.visible = YES;
    self.isPlayerBullet = isPlayerBullet;
    
    //通过设置一个不同的sprite frame，来显示改变bullet的纹理
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [self setSpriteFrame:frame];
    
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:-360.0f];
    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:rotate];
    [self runAction:repeat];
}

- (void)shootMissileWithFrameName:(NSString *)frameName isPlayerBullet:(BOOL)isPlayerBullet{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    self.visible = YES;
    self.isPlayerBullet = isPlayerBullet;
    self.position = CGPointMake(0.0f, CCRANDOM_0_1() * screenSize.height);
    
    //通过设置一个不同的sprite frame，来显示改变bullet的纹理
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [self setSpriteFrame:frame];
    
    //添加所有的图片纹理集对应的plist文件
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"game-art.plist"];
    NSMutableArray *missileFrames = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        NSString *frameName = [NSString stringWithFormat:@"missile-anim%ld.png",(long)i];
        CCSpriteFrame *spriteFrame = [frameCache spriteFrameByName:frameName];
        [missileFrames addObject:spriteFrame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:missileFrames delay:0.08f];
    
    CCActionAnimate *animate = [CCActionAnimate actionWithAnimation:animation];
    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:animate];
    [self runAction:repeat];
    
    CCActionMoveTo *moveAction = [CCActionMoveTo actionWithDuration:2.0f position:CGPointMake(screenSize.width + self.contentSize.width * 0.5f, self.position.y)];
    [self runAction:moveAction];
}

- (void)update:(CCTime)delta{
    self.position = ccpAdd(self.position, self.velocity);
    
    //子弹出屏幕外设为不可见
    if (CGRectIntersectsRect([self boundingBox], [GameScene screenRect]) == NO) {
        self.visible = NO;
        [self stopAllActions];
        [self unscheduleAllSelectors];
    }
}

// -----------------------------------------------------------------

@end





