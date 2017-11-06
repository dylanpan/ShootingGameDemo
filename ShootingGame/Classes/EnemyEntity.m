//
//  EnemyEntity.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "EnemyEntity.h"
#import "ShipEntity.h"
#import "GameScene.h"
#import "StandardMoveComponent.h"
#import "StandardShootComponent.h"
#import "HealthbarComponent.h"
#import "ScoreComponent.h"
#import "ShieldbarComponent.h"
#import "EnergybarComponent.h"
#import "BuffComponent.h"
#import "CCAnimation+Helper.h"

#define enemySpawnFrequencyOfTypeBreadman 120
#define enemySpawnFrequencyOfTypeSnake 300
#define enemySpawnFrequencyOfTypeBoss 1500

@interface EnemyEntity(PrivateMethods)
+ (NSMutableArray *)getSpawnFrequency;
@end
// -----------------------------------------------------------------

@implementation EnemyEntity

// -----------------------------------------------------------------
+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

- (id)initWithType:(EnemyTypes)enemyType{
    _type = enemyType;
    NSString *frameName;
    NSString *bulletFrameName;
    NSInteger shootFrequency = 300;
    _initialHitPoints = 1;
    
    switch (_type) {
        case EnemyTypeBreadman:
            frameName = @"monster-a0.png";
            bulletFrameName = @"candystick.png";
            break;
            
        case EnemytypeSnake:
            frameName = @"monster-b0.png";
            bulletFrameName = @"redcross.png";
            shootFrequency = 200;
            _initialHitPoints = 3;
            break;
            
        case EnemyTypeBoss:
            frameName = @"monster-c0.png";
            bulletFrameName = @"blackhole.png";
            shootFrequency = 100;
            _initialHitPoints = 30;
            _initialShieldPoints = 15.0f;
            _initialEnergyPoints = 15.0f;
            break;
            
        default:
            [NSException exceptionWithName:@"EnemyEntity Exception" reason:@"unhandled enemy type" userInfo:nil];
            break;
    }
    
    if (self = [super initWithImageNamed:frameName]) {
        [self addChild:[StandardMoveComponent node]];
        
        StandardShootComponent *shootComponent = [StandardShootComponent node];
        shootComponent.shootFrequency = shootFrequency;
        shootComponent.bulletFrameName = bulletFrameName;
        [self addChild:shootComponent];
        
        self.visible = NO;
    }
    
    return self;
}

+ (id)enemyWithType:(EnemyTypes)enemyType{
    //return [[[self alloc] initWithType:enemyType] autorelease];
    return [[self alloc] initWithType:enemyType];
}

//static NSMutableArray *spawnFrequency;

+ (NSMutableArray *)getSpawnFrequency{
    NSMutableArray *spawnFrequency = [[NSMutableArray alloc] init];
    
    spawnFrequency = [[NSMutableArray alloc] initWithCapacity:EnemyType_MAX];
    [spawnFrequency insertObject:[NSNumber numberWithUnsignedInteger:enemySpawnFrequencyOfTypeBreadman] atIndex:EnemyTypeBreadman];
    [spawnFrequency insertObject:[NSNumber numberWithUnsignedInteger:enemySpawnFrequencyOfTypeSnake] atIndex:EnemytypeSnake];
    [spawnFrequency insertObject:[NSNumber numberWithUnsignedInteger:enemySpawnFrequencyOfTypeBoss] atIndex:EnemyTypeBoss];
    
    return spawnFrequency;
}

+ (NSInteger)getSpawnFrequencyForEnemyType:(EnemyTypes)enemyType{
    NSAssert(enemyType < EnemyType_MAX, @"invalid enemy type");
    NSMutableArray *spawnFrequency = [self getSpawnFrequency];
    NSNumber *number = [spawnFrequency objectAtIndex:enemyType];
    return [number integerValue];
}

//- (void)dealloc{
//    [spawnFrequency release];
//    spawnFrequency = nil;
//    [super dealloc];
//}

- (void)spawn{
    CGRect screenRect = [GameScene screenRect];
    CGSize spriteSize = [self contentSize];
    float posX = screenRect.size.width + spriteSize.width * 0.5f - 1.0f;
    float posY = CCRANDOM_0_1() * (screenRect.size.height - spriteSize.height) + spriteSize.height * 0.5f;
    self.position = CGPointMake(posX, posY);
    //self.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.visible = YES;
    
    //添加动画
    CCAnimation *animation;
    if (self.type == EnemyTypeBreadman) {
        animation = [CCAnimation animationWithFrame:[NSString stringWithFormat:@"monster-a"] frameCount:2 delay:0.5f];
    }else if (self.type == EnemytypeSnake) {
        animation = [CCAnimation animationWithFrame:[NSString stringWithFormat:@"monster-b"] frameCount:2 delay:0.5f];
    }else if (self.type == EnemyTypeBoss) {
        animation = [CCAnimation animationWithFrame:[NSString stringWithFormat:@"monster-c"] frameCount:2 delay:0.5f];
    }
    CCActionAnimate *animate = [CCActionAnimate actionWithAnimation:animation];
    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:animate];
    [self runAction:repeat];
    
    //初始化生命、护盾、能量槽
    _hitPoints = _initialHitPoints;
    _shieldPoints = _initialShieldPoints;
    _energyPoints = 0;
    
    if (self.type == EnemyTypeBoss) {
        //添加血条
        HealthbarComponent *healthBar = [HealthbarComponent node];
        [[GameScene shareGameScene] addChild:healthBar];
        [healthBar resetWithType:HealthBarTypeEnemy];
        //添加护盾
        ShieldbarComponent *shieldBar = [ShieldbarComponent node];
        [[GameScene shareGameScene] addChild:shieldBar];
        [shieldBar resetShieldbarWithType:ShieldbarTypeEnemy];
        //添加能量槽
        EnergybarComponent *energyBar = [EnergybarComponent node];
        [[GameScene shareGameScene] addChild:energyBar];
        [energyBar resetEnergybarWithType:EnergybarTypeEnemy];
        //添加出场音效
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isEffectOn = [defaults boolForKey:@"isEffectOn"];
        if (isEffectOn) {
            [[OALSimpleAudio sharedInstance] setBgVolume:0.3f];
             _bossComingEffect = [[OALSimpleAudio sharedInstance] playEffect:@"BossComing.caf" volume:2.5f pitch:1.2f pan:0.0f loop:YES];
        }
        //添加警示动画
        //红线部分
        CCAnimation *animation = [CCAnimation animationWithFrame:[NSString stringWithFormat:@"boss-showup-anim"] frameCount:4 delay:0.1f];
        CCActionAnimate *animAction = [CCActionAnimate actionWithAnimation:animation];
        CCActionRepeatForever *repeatAction = [CCActionRepeatForever actionWithAction:animAction];
        [GameScene shareGameScene].backgroundSpriteAnim.visible = YES;
        [[GameScene shareGameScene].backgroundSpriteAnim runAction:repeatAction];
        //红字部分
        CCActionMoveTo *bossLabelMoveAction1 = [CCActionMoveTo actionWithDuration:0.5f position:CGPointMake(screenRect.size.width * 0.5f, screenRect.size.height * 0.5f)];
        CCActionBlink *bossLabelBlinkAction = [CCActionBlink actionWithDuration:1.0f blinks:5];
        CCActionMoveTo *bossLabelMoveAction2 = [CCActionMoveTo actionWithDuration:0.5f position:CGPointMake(-[GameScene shareGameScene].bossShowupLabel.contentSize.width * 0.5f, screenRect.size.height * 0.5f)];
        CCActionCallFunc *bossLabelActionDone = [CCActionCallFunc actionWithTarget:self selector:@selector(bossShowup)];
        CCActionSequence *bossLabelActionSequence = [CCActionSequence actions:bossLabelMoveAction1, bossLabelBlinkAction, bossLabelMoveAction2, bossLabelActionDone, nil];
        [GameScene shareGameScene].bossShowupLabel.visible = YES;
        [[GameScene shareGameScene].bossShowupLabel runAction:bossLabelActionSequence];
    }
}

- (void)bossShowup{
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    //停止backgroundSpriteAnim的动画并不可见
    [GameScene shareGameScene].backgroundSpriteAnim.visible = NO;
    [[GameScene shareGameScene].backgroundSpriteAnim stopAllActions];
    //停止bossShowupLabel的动画并不可见，同时重置初始位置
    [GameScene shareGameScene].bossShowupLabel.visible = NO;
    [[GameScene shareGameScene].bossShowupLabel stopAllActions];
    [GameScene shareGameScene].bossShowupLabel.position = CGPointMake(screenSize.width, screenSize.height * 0.5f);
    if (_bossComingEffect !=nil) {
        [_bossComingEffect stop];
        [[OALSimpleAudio sharedInstance] setBgVolume:1.0f];
    }
}

- (void)spawnBuffCapacity:(NSInteger)capacity{
    if (capacity != 0) {
        BuffComponent *buffComponent = [BuffComponent buffWithType:BuffTypeScore];
        buffComponent.type = BuffTypeScore;
        [buffComponent spawnBuffWithPosition:[self getBuffPosition:capacity]];
        [[GameScene shareGameScene] addChild:buffComponent];
        capacity--;
        [self spawnBuffCapacity:capacity];
    }
}

//获取离散点
- (CGPoint)getBuffPosition:(NSInteger)x{
    //double y = log10(x) / log10(50) + 1.0f;
    CGFloat y = 0.3f * sinf(0.3f * x) + 1;
    CGPoint pos = ccpMult(self.position, y);
    pos = ccpSub(pos, CGPointMake(self.contentSize.width, self.contentSize.height * 0.5f));
    return pos;
}

- (void)gotHit{
    if (_shieldPoints > 0.0f) {
        _shieldPoints--;
    }else if (_shieldPoints <= 0.0f) {
        _hitPoints--;
    }
    
    [ShieldbarComponent checkEnemyIsUnderAttack:YES];
    
    if (_hitPoints <= 0) {
        self.visible = NO;
        
        //得分
        if (self.type == EnemyTypeBreadman) {
            [[ScoreComponent node] getScore:ScoreTypeBreadman];
        }else if (self.type == EnemytypeSnake) {
            [[ScoreComponent node] getScore:ScoreTypeSnake];
        }else if (self.type == EnemyTypeBoss) {
            [[ScoreComponent node] getScore:ScoreTypeBoss];
        }
        
        //增加energy
        ShipEntity *ship = [[GameScene shareGameScene] defaultShip];
        ship.energyPoints++;
        if (ship.energyPoints >= ship.initialEnergyPoints) {
            ship.energyPoints = ship.initialEnergyPoints;
        }
        
        //添加粒子特效
        CCParticleSystem *system;
        if (_type == EnemyTypeBoss) {
            system = [CCParticleSystem particleWithFile:@"fx-explosion2.plist"];
        }else{
            system = [CCParticleSystem particleWithFile:@"fx-explosion.plist"];
        }
        
        system.particlePositionType = CCParticleSystemPositionTypeFree;
        system.autoRemoveOnFinish = YES;
        system.position = self.position;
        
        //添加粒子特效到scene的原因：
        //1.self现在是不可见，会影响粒子特效；
        //2.self是sprite，要添加到sprite batch中，而sprite batch只允许sprite为children；
        //3.粒子特效时间短，添加到scene中影响不大
        [[GameScene shareGameScene] addChild:system];
        
        //生成buff
        if (self.type == EnemyTypeBoss) {
            [self spawnBuffCapacity:4];
        }else{
            [self spawnBuffCapacity:1];
        }
        
    }
}

// -----------------------------------------------------------------

@end





