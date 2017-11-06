//
//  StandardMoveComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "StandardMoveComponent.h"
#import "Entity.h"
#import "GameScene.h"
#import "BuffComponent.h"

// -----------------------------------------------------------------

@implementation StandardMoveComponent

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
        _velocity = CGPointMake(-1.0f, 0.0f);
    }
    
    return self;
}

//判断两个矩形相交
- (BOOL)checkEntity:(CGRect)entityRect intersectsScene:(CGRect)screenRect{
    //分别获取两个矩形的左下角和右上角坐标
    CGPoint entityLDCorner = CGPointMake(entityRect.origin.x - entityRect.size.width * 0.5f, entityRect.origin.y - entityRect.size.height * 0.5f);
    CGPoint entityRUCorner = CGPointMake(entityRect.origin.x + entityRect.size.width * 0.5f, entityRect.origin.y + entityRect.size.height * 0.5f);
    CGPoint screenLDCorner = CGPointMake(screenRect.origin.x, screenRect.origin.y);
    CGPoint screenRUCorner = CGPointMake(screenRect.origin.x + screenRect.size.width, screenRect.origin.y + screenRect.size.height);
    
    //比较左下角对应的两个X和Y值，取最大值构成M点
    CGFloat crossMPointX = entityLDCorner.x > screenLDCorner.x ? entityLDCorner.x : screenLDCorner.x;
    CGFloat crossMPointY = entityLDCorner.y > screenLDCorner.y ? entityLDCorner.y : screenLDCorner.y;
    
    //比较右上角对应的两个X和Y值，取最小值构成N点
    CGFloat crossNPointX = entityRUCorner.x < screenRUCorner.x ? entityRUCorner.x : screenRUCorner.x;
    CGFloat crossNPointY = entityRUCorner.y < screenRUCorner.y ? entityRUCorner.y : screenRUCorner.y;
    
    //比较M点的X和Y值均比N点的X和Y值小，则两个矩形相交
    return (crossMPointX < crossNPointX && crossMPointY < crossNPointY);
}

- (void)update:(CCTime)delta{
    if (self.parent.visible) {
        if ([self.parent isKindOfClass:[Entity class]]) {
            Entity *entity = (Entity *)self.parent;
            CGRect screenRect = [GameScene screenRect];
            CGRect entityRect = CGRectMake(entity.position.x - entity.contentSize.width * 0.5f, entity.position.y - entity.contentSize.height * 0.5f, entity.contentSize.width, entity.contentSize.height);
            BOOL isIntersects = [self checkEntity:entityRect intersectsScene:screenRect];
            if (isIntersects) {
                [entity setPosition:ccpAdd(entity.position, _velocity)];
            }else{
                entity.visible = NO;
                [entity stopAllActions];
                [entity unscheduleAllSelectors];
            }
        }else if ([self.parent isKindOfClass:[BuffComponent class]]) {
            _updateCount++;
            BuffComponent *buff = (BuffComponent *)self.parent;
            CGRect screenRect = [GameScene screenRect];
            CGRect buffRect = CGRectMake(buff.buffSprite.position.x - buff.buffSprite.contentSize.width * 0.5f, buff.buffSprite.position.y - buff.buffSprite.contentSize.height * 0.5f, buff.buffSprite.contentSize.width, buff.buffSprite.contentSize.height);
            //NSLog(@"\nbuff rect:%f,%f,%f,%f",buffRect.origin.x,buffRect.origin.y,buffRect.size.width,buffRect.size.height);
            BOOL isIntersects = [self checkEntity:buffRect intersectsScene:screenRect];
            if (isIntersects) {
                [buff setBuffSpritePosition:ccpAdd(buff.buffSprite.position, CGPointMake(-1.0f, 0.4f))];
                if (_updateCount % 200 == 0) {
                    [buff setBuffSpritePosition:ccpAdd(buff.buffSprite.position, CGPointMake(-1.0f, -1.0f))];
                    _updateCount = 199;
                }
            }else{
                buff.visible = NO;
                [buff stopAllActions];
                [buff unscheduleAllSelectors];
            }
        }
//        }else{
//            NSAssert([self.parent isKindOfClass:[Entity class]], @"node is not a Entity");
//        }
    }
}

// -----------------------------------------------------------------

@end





