//
//  EnemyCache.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "EnemyCache.h"
#import "EnemyEntity.h"
#import "GameScene.h"
#import "BulletCache.h"
#import "ShipEntity.h"
#import "StandardMoveComponent.h"

@interface EnemyCache(PrivateMethods)
- (void)initEnemies;
@end
// -----------------------------------------------------------------

@implementation EnemyCache

// -----------------------------------------------------------------
+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

+ (id)cache{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

- (id)init{
    if (self = [super init]) {
        //CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monster-a.png"];
        //CCSprite *enemySpriteBatch = [CCSprite spriteWithTexture:frame.texture];
        //[self addChild:enemySpriteBatch];
        
        //调试boss设置的生成间隔:1799
        //_updateCount = 1799;
        [self initEnemies];
    }
    return self;
}

- (void)initEnemies{
    //创建数组包含所有enemy的类型
    _enemies = [[NSMutableArray alloc] initWithCapacity:EnemyType_MAX];
    NSMutableDictionary *enemyDictionary = [[NSMutableDictionary alloc] init];
    
    //为每一个类型的enemy创建数组，其中包含enemy个数
    for (NSInteger i = 0; i < EnemyType_MAX; i++) {
        NSInteger capacity;//每种类型对应的预设enemy数
        switch (i) {
            case EnemyTypeBreadman:
                capacity = 6;
                [enemyDictionary setObject:[NSNumber numberWithInteger:capacity] forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                break;
                
            case EnemytypeSnake:
                capacity = 3;
                [enemyDictionary setObject:[NSNumber numberWithInteger:capacity] forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                break;
                
            case EnemyTypeBoss:
                capacity = 1;
                [enemyDictionary setObject:[NSNumber numberWithInteger:capacity] forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                break;
                
            default:
                [NSException exceptionWithName:@"EnemyCache Exception" reason:@"unhandled enemy type" userInfo:nil];
                break;
        }
        
        NSMutableArray *enemiesOfType = [NSMutableArray arrayWithCapacity:capacity];
        [_enemies addObject:enemiesOfType];
    }
    
    for (NSInteger i = 0; i < EnemyType_MAX; i++) {
        NSMutableArray *enemiesOfType = [_enemies objectAtIndex:i];
        NSNumber *numEnemiesOfType = [enemyDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)i]];
        
        for (NSInteger j = 0; j < [numEnemiesOfType integerValue]; j++) {
            EnemyEntity *enemy = [EnemyEntity enemyWithType:i];
            [self addChild:enemy z:0 name:[NSString stringWithFormat:@"%ld",(long)i]];
            [enemiesOfType addObject:enemy];
        }
    }
}

//- (void)dealloc{
//    [_enemies release];
//    [super dealloc];
//}

- (void)spawnEnemyOfType:(EnemyTypes)enemyType{
    NSMutableArray *enemiesOfTpye = [_enemies objectAtIndex:enemyType];
    
    for (EnemyEntity *enemy in enemiesOfTpye) {
        if (enemy.visible == NO) {
            [enemy spawn];
            break;
        }
    }
}

- (void)checkForCollosions{
    BulletCache *bulletCache = [[GameScene shareGameScene] bulletCache];
    ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
    CGRect shipRect = CGRectMake(ship.position.x - ship.contentSize.width * 0.5f, ship.position.y - ship.contentSize.height * 0.5f, ship.contentSize.width, ship.contentSize.height);
    
    NSArray *batchArray = [self children];
    for (EnemyEntity *enemy in batchArray) {
        if (enemy.visible && ship.visible) {
            //enemy与ship碰撞
            CGRect enemyRect = CGRectMake(enemy.position.x - enemy.contentSize.width * 0.5f, enemy.position.y - enemy.contentSize.height * 0.5f, enemy.contentSize.width, enemy.contentSize.height);
            if ([[StandardMoveComponent node] checkEntity:enemyRect intersectsScene:shipRect]) {
                [ship gotHit];
                [enemy gotHit];
                [[OALSimpleAudio sharedInstance] vibrate];
                [[GameScene shareGameScene] shakeGameSceneWithEnemyType:enemy.type];
            }
            
            if (bulletCache.visible) {
                //enemy与player bullet碰撞
                if ([bulletCache isPlayerBulletCollidingWithRect:[enemy boundingBox]]) {
                    [enemy gotHit];
                }
                
                //enemy bullet与ship碰撞
                if ([bulletCache isEnemyBulletCollidingWithRect:[ship boundingBox]]) {
                    [ship gotHit];
                }
            }
        }
    }
}

- (void)update:(CCTime)delta{
    _updateCount++;
    
    //调试boss，记得init里面将updateCount设置成1799，可一开始生产boss
//    if (_updateCount % 1800 == 0) {
//        [self spawnEnemyOfType:EnemyTypeBoss];
//    }
    
    for (NSInteger i = EnemyType_MAX - 1; i >= 0 ; i--) {
        NSInteger spawnFrequency = [EnemyEntity getSpawnFrequencyForEnemyType:i];
        
        if (_updateCount % spawnFrequency == 0) {
            [self spawnEnemyOfType:i];
            break;
        }
    }
    
    
    [self checkForCollosions];
}

// -----------------------------------------------------------------

@end





