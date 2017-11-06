//
//  ScoreComponent.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/15
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "ScoreComponent.h"

// -----------------------------------------------------------------

@implementation ScoreComponent

// -----------------------------------------------------------------
static NSInteger instanceOfCurrentScore;
static NSInteger instanceOfFlightDistance;

+ (NSInteger)shareCurrentScore{
    return instanceOfCurrentScore;
}

+ (NSInteger)shareFlightDistance{
    return instanceOfFlightDistance;
}

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score:0"] fontName:@"ArialMT" fontSize:16];
        _scoreLabel.position = CGPointMake(screenSize.width * 0.6f, screenSize.height - _scoreLabel.contentSize.height * 0.5f);
        _scoreLabel.color = [CCColor whiteColor];
        [self addChild:_scoreLabel];
    }
    return self;
}

+ (NSInteger)getHighScore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [defaults integerForKey:@"highScore"];
    return highScore;
}

+ (void)storeHighScore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [defaults integerForKey:@"highScore"];
    //NSLog(@"high score:%ld",(long)highScore);
    instanceOfCurrentScore += instanceOfFlightDistance;
    //NSLog(@"total score:%ld",(long)instanceOfCurrentScore);
    if (instanceOfCurrentScore > highScore) {
        [defaults setInteger:instanceOfCurrentScore forKey:@"highScore"];
        [defaults synchronize];
    }
}

- (void)getScore:(ScoreTypes)type{
    instanceOfCurrentScore += type;
    _scoreLabel.string = [NSString stringWithFormat:@"%ld",(long)instanceOfCurrentScore];
    //NSLog(@"current score:%@",_scoreLabel.string);
}

+ (void)resetScore{
    instanceOfCurrentScore = 0;
    instanceOfFlightDistance = 0;
}

- (void)update:(CCTime)delta{
    _updateCount++;
    if (_updateCount % 30 == 0) {
        instanceOfFlightDistance++;
    }
    _scoreLabel.string = [NSString stringWithFormat:@"Score:%ld",(long)(instanceOfCurrentScore + instanceOfFlightDistance)];
}

// -----------------------------------------------------------------

@end





