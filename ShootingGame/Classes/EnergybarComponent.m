//
//  EnergybarComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/31
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "EnergybarComponent.h"
#import "HealthbarComponent.h"
#import "ShieldbarComponent.h"
#import "GameScene.h"
#import "ShipEntity.h"
#import "EnemyCache.h"
#import "EnemyEntity.h"
#import "StandardMoveComponent.h"
#import "CCAnimation+Helper.h"


// -----------------------------------------------------------------

@implementation EnergybarComponent

// -----------------------------------------------------------------
+ (instancetype)node{
    return [[self alloc] initWithEnergybarImageName];
}

- (instancetype)initWithEnergybarImageName{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        _energybarSprite = [CCSprite spriteWithImageNamed:@"energybar.png"];
        [self addChild:_energybarSprite z:0];
        
        _border = [CCSprite spriteWithImageNamed:@"borderbar1.png"];
        [self addChild:_border z:-1];
        
        self.visible = NO;
    }
    
    return self;
}

- (void)resetEnergybarWithType:(EnergybarTypes)type{
    //挂在sprite的头顶
    //    float parentHeight = self.parent.contentSize.height;
    //    float selfHeight = self.contentSize.height;
    //    self.position = CGPointMake(self.parent.anchorPointInPoints.x, parentHeight + selfHeight);
    
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    CGFloat energyBarWidth = _energybarSprite.contentSize.width;
    CGFloat energyBarHeight = _energybarSprite.contentSize.height;
    HealthbarComponent *healthbarComponent = [HealthbarComponent node];
    CGFloat healthBarHeight = healthbarComponent.healthbarSprite.contentSize.height;
    ShieldbarComponent *shieldbarComponent = [ShieldbarComponent node];
    CGFloat shieldBarHeight = shieldbarComponent.shieldbarSprite.contentSize.height;
    _type = type;
    switch (type) {
        case EnergybarTypeShip:
            _energybarSprite.position = CGPointMake(0.0f, screenHeight - energyBarHeight - shieldBarHeight - healthBarHeight);
            _energybarSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
            _border.position = CGPointMake(0.0f, screenHeight - energyBarHeight - shieldBarHeight - healthBarHeight);
            _border.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
            
        case EnergybarTypeEnemy:
            _energybarSprite.position = CGPointMake(screenWidth - energyBarWidth, screenHeight - energyBarHeight - shieldBarHeight - healthBarHeight);
            _energybarSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
            _border.position = CGPointMake(screenWidth - energyBarWidth, screenHeight - energyBarHeight - shieldBarHeight - healthBarHeight);
            _border.anchorPoint = CGPointMake(0.0f, 0.0f);
            break;
            
        default:
            [NSException exceptionWithName:@"EnergyComponent Exception" reason:@"unhandled energyBar type" userInfo:nil];
            break;
    }
    
    _energybarSprite.scaleX = 1.0f;
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
        /*
         enemy:出现后开始以0.01的速度进行energy增加
         ship:每击杀一个敌人energy增加1
         */
        if (_type == EnergybarTypeEnemy) {
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
                        if (enemy.energyPoints < enemy.initialEnergyPoints) {
                            self.visible = YES;
                            enemy.energyPoints += 0.01f;//调整恢复速度:0.01
                            _energybarSprite.scaleX = enemy.energyPoints /enemy.initialEnergyPoints;
                            if (_energybarSprite.scaleX == 1.0f) {
                                enemy.energyPoints = enemy.initialEnergyPoints;
                            }
                        }
                    }else if (isIntersects == NO || enemy.hitPoints <= 0) {
                        self.visible = NO;
                    }
                }
            }
        }
        
        if (_type == EnergybarTypeShip) {
            ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
            if (ship.hitPoints > 0) {
                _energybarSprite.scaleX = ship.energyPoints/(float)ship.initialEnergyPoints;
            }else{
                self.visible = NO;
            }
        }
    }else if (self.visible){
        self.visible = NO;
    }
    
}

// -----------------------------------------------------------------

@end





