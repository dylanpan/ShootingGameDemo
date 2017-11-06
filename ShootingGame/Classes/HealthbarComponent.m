//
//  HealthbarComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HealthbarComponent.h"
#import "GameScene.h"
#import "EnemyEntity.h"
#import "ShipEntity.h"
#import "EnemyCache.h"
#import "StandardMoveComponent.h"

// -----------------------------------------------------------------

@implementation HealthbarComponent

// -----------------------------------------------------------------
+ (instancetype)node{
    return [[self alloc] initWithHealthbarImageName];
}

- (instancetype)initWithHealthbarImageName{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        _healthbarSprite = [CCSprite spriteWithImageNamed:@"healthbar.png"];
        [self addChild:_healthbarSprite z:0];
        
        _border = [CCSprite spriteWithImageNamed:@"borderbar.png"];
        [self addChild:_border z:-1];
        
        self.visible = NO;
    }
    
    return self;
}

- (void)resetWithType:(HealthBarTypes)type{
    //挂在sprite的头顶
//    float parentHeight = self.parent.contentSize.height;
//    float selfHeight = self.contentSize.height;
//    self.position = CGPointMake(self.parent.anchorPointInPoints.x, parentHeight + selfHeight);
    
    CGFloat screenWidth = [GameScene screenRect].size.width;
    CGFloat screenHeight = [GameScene screenRect].size.height;
    CGFloat healthBarWidth = _healthbarSprite.contentSize.width;
    CGFloat healthBarHeight = _healthbarSprite.contentSize.height;
    _type = type;
    switch (type) {
        case HealthBarTypeShip:
            _healthbarSprite.position = CGPointMake(0.0f, screenHeight - healthBarHeight);
            _healthbarSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
            _border.position = CGPointMake(0.0f, screenHeight - healthBarHeight);
            _border.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
        case HealthBarTypeEnemy:
            _healthbarSprite.position = CGPointMake(screenWidth - healthBarWidth, screenHeight - healthBarHeight);
            _healthbarSprite.anchorPoint = CGPointMake(0.0f,0.0f);
            _border.position = _healthbarSprite.position;
            _border.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
            
        default:
            [NSException exceptionWithName:@"HealthbarComponent Exception" reason:@"unhandled healthBar type" userInfo:nil];
            break;
    }
    
    _healthbarSprite.scaleX = 1.0f;
    self.visible = YES;
}

- (void)update:(CCTime)delta{
    //挂头顶的血条的判断
//    if (self.parent.visible) {
//        if ([self.parent isKindOfClass:[EnemyEntity class]]) {
//            EnemyEntity *parentEnemy = (EnemyEntity *)self.parent;
//            self.scaleX = parentEnemy.hitPoints/(float)parentEnemy.initialHitPoints;
//        }
//
//        if ([self.parent isKindOfClass:[ShipEntity class]]) {
//            ShipEntity *parentShip = (ShipEntity *)self.parent;
//            self.scaleX = parentShip.hitPoints/(float)parentShip.initialHitPoints;
//        }
//
//        if ([self.parent isKindOfClass:[EnemyEntity class]] != YES ) {
//            if ([self.parent isKindOfClass:[ShipEntity class]] != YES ) {
//                NSAssert(([self.parent isKindOfClass:[EnemyEntity class]]) || ([self.parent isKindOfClass:[ShipEntity class]]), @"not a EnemyEntity or ShipEntity");
//            }
//        }
//    }else if (self.visible){
//        self.visible = NO;
//    }
    
    
    if (self.parent.visible) {
        if (_type == HealthBarTypeEnemy) {
            CGRect screenRect = [GameScene screenRect];
            CGRect enemyRect;
            CCNode *node = [[GameScene shareGameScene] getChildByName:@"GameSceneNodeTagEnemyCache" recursively:YES];
            EnemyCache *enemyCache = (EnemyCache *)node;
            NSArray *enemyArray = [enemyCache children];
            for (EnemyEntity *enemy in enemyArray) {
                if (enemy.type == EnemyTypeBoss) {
                    enemyRect = CGRectMake(enemy.position.x - enemy.contentSize.width * 0.5f, enemy.position.y - enemy.contentSize.height * 0.5f, enemy.contentSize.width, enemy.contentSize.height);
                    BOOL isIntersects = [[StandardMoveComponent node] checkEntity:enemyRect intersectsScene:screenRect];
                    if (enemy.hitPoints > 0 && isIntersects == YES) {
                        self.visible = YES;
                        _healthbarSprite.scaleX = enemy.hitPoints/(float)enemy.initialHitPoints;
                    }else if (isIntersects == NO || enemy.hitPoints <= 0) {
                        self.visible = NO;
                    }
                }
            }
        }
        
        if (_type == HealthBarTypeShip) {
            ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
            _healthbarSprite.scaleX = ship.hitPoints/(float)ship.initialHitPoints;
            if (_healthbarSprite.scaleX == 0) {
                self.visible = NO;
            }
        }
    }else if (self.visible){
        self.visible = NO;
    }
    
}

// -----------------------------------------------------------------

@end





