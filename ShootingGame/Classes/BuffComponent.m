//
//  BuffComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/15
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "BuffComponent.h"
#import "StandardMoveComponent.h"
#import "GameScene.h"
#import "ShipEntity.h"
#import "ScoreComponent.h"

// -----------------------------------------------------------------

@implementation BuffComponent

// -----------------------------------------------------------------

+ (id)buffWithType:(BuffTypes)type{
    return [[self alloc] initWithBuffType:type];
}

- (id)initWithBuffType:(BuffTypes)type{
    self = [super init];
    if (self) {
        switch (type) {
            case BuffTypeScore:
                _buffSprite = [CCSprite spriteWithImageNamed:@"buff-point.png"];
                break;
                
            case BuffTypeAttack:
                _buffSprite = [CCSprite spriteWithImageNamed:@"buff-attack.png"];
                break;
                
            case BuffTypeDefence:
                _buffSprite = [CCSprite spriteWithImageNamed:@"buff-defence.png"];
                break;
                
            case BuffTypeSpeed:
                _buffSprite = [CCSprite spriteWithImageNamed:@"buff-speed.png"];
                break;
                
            default:
                [NSException exceptionWithName:@"BuffComponent Exception" reason:@"unhandled buff type" userInfo:nil];
                break;
        }
        [self addChild:_buffSprite];
        [self addChild:[StandardMoveComponent node]];
        CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:-360.0f];
        CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:rotate];
        [_buffSprite runAction:repeat];
    }
    return self;
}

- (void)spawnBuffWithPosition:(CGPoint)pos{
    _buffSprite.position = pos;
    _buffSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
}



- (void)setBuffSpritePosition:(CGPoint)position{
    //如果现在的位置在屏幕外，不用调整；允许entity从屏幕外进入屏幕内
    if (CGRectContainsRect([GameScene screenRect], [_buffSprite boundingBox])) {
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        float halfWidth = _buffSprite.contentSize.width * 0.5f;
        float halfHeight = _buffSprite.contentSize.height * 0.5f;
        
        if (position.x < halfWidth) {
            position.x = halfWidth;
        }else if (position.x > (screenSize.width - halfWidth)){
            position.x = screenSize.width - halfWidth;
        }
        
        if (position.y < halfHeight) {
            position.y = halfHeight;
        }else if (position.y > (screenSize.height - halfHeight)){
            position.y = screenSize.height - halfHeight;
        }
    }
    _buffSprite.position = position;
}


- (void)checkBuffCollisions:(BuffTypes)type buffRect:(CGRect)buffRect shipRect:(CGRect)shipRect{
    BOOL isCollisions = [[StandardMoveComponent node] checkEntity:buffRect intersectsScene:shipRect];
    if (isCollisions) {
        switch (type) {
            case BuffTypeScore:
                [self buffTypeScoreEffect];
                break;
                
            case BuffTypeAttack:
                NSLog(@"didnot add effect method");
                break;
                
            case BuffTypeDefence:
                NSLog(@"didnot add effect method");
                break;
                
            case BuffTypeSpeed:
                NSLog(@"didnot add effect method");
                break;
                
            default:
                [NSException exceptionWithName:@"BuffComponent Exception" reason:@"unhandled buff type" userInfo:nil];
                break;
        }
    }
}

- (void)buffTypeScoreEffect{
    [[ScoreComponent node] getScore:ScoreTypeBuffScore];
    self.visible = NO;
}

- (void)update:(CCTime)delta{
    if (self.visible) {
        CGRect buffRect = CGRectMake(_buffSprite.position.x - _buffSprite.contentSize.width * 0.5f, _buffSprite.position.y - _buffSprite.contentSize.height * 0.5f, _buffSprite.contentSize.width, _buffSprite.contentSize.height);
        ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
        //NSLog(@"\nbuff rect:%f,%f,%f,%f",buffRect.origin.x,buffRect.origin.y,buffRect.size.width,buffRect.size.height);
        CGRect shipRect = CGRectMake(ship.position.x - ship.contentSize.width * 0.5f, ship.position.y - ship.contentSize.height * 0.5f, ship.contentSize.width, ship.contentSize.height);
        [self checkBuffCollisions:_type buffRect:buffRect shipRect:shipRect];
    }
    
}

// -----------------------------------------------------------------

@end





