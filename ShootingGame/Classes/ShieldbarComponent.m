//
//  ShieldbarComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/31
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "ShieldbarComponent.h"
#import "HealthbarComponent.h"
#import "GameScene.h"
#import "EnemyCache.h"
#import "EnemyEntity.h"
#import "ShipEntity.h"
#import "StandardMoveComponent.h"

// -----------------------------------------------------------------

@implementation ShieldbarComponent

// -----------------------------------------------------------------
static BOOL playerIsUnderAttack;
static BOOL enemyIsUnderAttack;

+ (instancetype)node{
    return [[self alloc] initWithShieldbarImageName];
}

- (instancetype)initWithShieldbarImageName{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        _shieldbarSprite = [CCSprite spriteWithImageNamed:@"shieldbar.png"];
        [self addChild:_shieldbarSprite z:0];
        
        _border = [CCSprite spriteWithImageNamed:@"borderbar1.png"];
        [self addChild:_border z:-1];
        
        playerIsUnderAttack = NO;
        enemyIsUnderAttack = NO;
        self.visible = NO;
    }
    
    return self;
}

- (void)resetShieldbarWithType:(ShieldbarTypes)type{
    //挂在sprite的头顶
    //    float parentHeight = self.parent.contentSize.height;
    //    float selfHeight = self.contentSize.height;
    //    self.position = CGPointMake(self.parent.anchorPointInPoints.x, parentHeight + selfHeight);
    
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    CGFloat shieldBarWidth = _shieldbarSprite.contentSize.width;
    CGFloat shieldBarHeight = _shieldbarSprite.contentSize.height;
    HealthbarComponent *healthbarComponent = [HealthbarComponent node];
    CGFloat healthBarHeight = healthbarComponent.healthbarSprite.contentSize.height;
    _type = type;
    switch (type) {
        case ShieldbarTypeShip:
            _shieldbarSprite.position = CGPointMake(0.0f, screenHeight - shieldBarHeight - healthBarHeight);
            _shieldbarSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
            _border.position = CGPointMake(0.0f, screenHeight - shieldBarHeight - healthBarHeight);
            _border.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
        case ShieldbarTypeEnemy:
            _shieldbarSprite.position = CGPointMake(screenWidth - shieldBarWidth, screenHeight - shieldBarHeight - healthBarHeight);
            _shieldbarSprite.anchorPoint = CGPointMake(0.0f,0.0f);
            _border.position = CGPointMake(screenWidth - shieldBarWidth, screenHeight - shieldBarHeight - healthBarHeight);
            _border.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
            
        default:
            [NSException exceptionWithName:@"ShieldbarComponent Exception" reason:@"unhandled shieldBar type" userInfo:nil];
            break;
    }
    
    _shieldbarSprite.scaleX = 1.0f;
    self.visible = YES;
}

+ (void)checkShipIsUnderAttack:(BOOL)isAttack{
    playerIsUnderAttack = isAttack;
}

+ (void)checkEnemyIsUnderAttack:(BOOL)isAttack{
    enemyIsUnderAttack = isAttack;
}

- (void)recoverShieldbarAnim{
    NSLog(@"recovering...");
}

- (void)update:(CCTime)delta{
    //挂头顶的护盾的判断
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
        /*
         1.未受到攻击开始计时6秒
         2.当未受到攻击开始已经6秒且护盾受损，开始恢复护盾
         3.任何时刻，只要受到攻击，停止恢复护盾，并开始扣减护盾
         */
        CGRect screenRect = [GameScene screenRect];
        CGRect enemyRect;
        if (enemyIsUnderAttack) {
            if (_type == ShieldbarTypeEnemy) {
                CCNode *node = [[GameScene shareGameScene] getChildByName:@"GameSceneNodeTagEnemyCache" recursively:YES];
                EnemyCache *enemyCache = (EnemyCache *)node;
                NSArray *enemyArray = [enemyCache children];
                for (EnemyEntity *enemy in enemyArray) {
                    if (enemy.type == EnemyTypeBoss) {
                        enemyRect = CGRectMake(enemy.position.x - enemy.contentSize.width * 0.5f, enemy.position.y - enemy.contentSize.height * 0.5f, enemy.contentSize.width, enemy.contentSize.height);
                        BOOL isIntersects = [[StandardMoveComponent node] checkEntity:enemyRect intersectsScene:screenRect];
                        if (enemy.hitPoints > 0 && isIntersects == YES) {
                            self.visible = YES;
                            _shieldbarSprite.scaleX = enemy.shieldPoints/enemy.initialShieldPoints;
                            enemyIsUnderAttack = NO;
                            _updateCount = 0;
                        }else if (isIntersects == NO || enemy.hitPoints <= 0) {
                            self.visible = NO;
                        }
                    }
                }
            }
        }else{
            if (_type == ShieldbarTypeEnemy) {
                CCNode *node = [[GameScene shareGameScene] getChildByName:@"GameSceneNodeTagEnemyCache" recursively:YES];
                EnemyCache *enemyCache = (EnemyCache *)node;
                NSArray *enemyArray = [enemyCache children];
                for (EnemyEntity *enemy in enemyArray) {
                    if (enemy.type == EnemyTypeBoss) {
                        enemyRect = CGRectMake(enemy.position.x - enemy.contentSize.width * 0.5f, enemy.position.y - enemy.contentSize.height * 0.5f, enemy.contentSize.width, enemy.contentSize.height);
                        BOOL isIntersects = [[StandardMoveComponent node] checkEntity:enemyRect intersectsScene:screenRect];
                        if (enemy.hitPoints > 0 && isIntersects == YES) {
                            _updateCount++;
                            if ((_updateCount % 180 == 0) && (enemy.initialShieldPoints > enemy.shieldPoints)) {
                                _updateCount--;
                                enemy.shieldPoints += 0.01f;//调整恢复速度:0.01
                                _shieldbarSprite.scaleX = enemy.shieldPoints /enemy.initialShieldPoints;
                                if (_shieldbarSprite.scaleX == 1.0f) {
                                    _updateCount = 0;
                                }
                            }
                        }else if (isIntersects == NO || enemy.hitPoints <= 0) {
                            self.visible = NO;
                        }
                    }
                }
            }
        }
        if (playerIsUnderAttack) {
            if (_type == ShieldbarTypeShip) {
                ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
                if (ship.hitPoints > 0) {
                    _shieldbarSprite.scaleX = ship.shieldPoints/ship.initialShieldPoints;
                    playerIsUnderAttack = NO;
                    _updateCount = 0;
                }else{
                    self.visible = NO;
                }
            }
        }else if (playerIsUnderAttack == NO) {
            if (_type == ShieldbarTypeShip) {
                ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
                if (ship.hitPoints > 0) {
                    _updateCount++;
                    if ((playerIsUnderAttack == NO) && (_updateCount % 120 == 0) && (ship.initialShieldPoints > ship.shieldPoints)) {
                        _updateCount--;
                        ship.shieldPoints += 0.01f;//调整恢复速度:0.01
                        _shieldbarSprite.scaleX = ship.shieldPoints /ship.initialShieldPoints;
                        if (_shieldbarSprite.scaleX == 1.0f || playerIsUnderAttack == YES) {
                            _updateCount = 0;
                        }
                    }
                }else{
                    self.visible = NO;
                }
            }
        }
    }else if (self.visible){
        self.visible = NO;
    }
    
}

// -----------------------------------------------------------------

@end





