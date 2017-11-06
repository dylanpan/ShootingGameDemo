//
//  GameCreditsLayer.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/30
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameCreditsLayer.h"
#import "GameStartLayer.h"

// -----------------------------------------------------------------

@implementation GameCreditsLayer

// -----------------------------------------------------------------
+ (id)scene{
    CCScene *scene = [CCScene node];
    GameCreditsLayer *gameCreditsLayer = [GameCreditsLayer node];
    [scene addChild:gameCreditsLayer];
    scene.name = @"GameCreditsLayer";
    return scene;
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
        self.userInteractionEnabled = YES;
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        CCNodeColor *backgroundLayer = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:69.0f/255.0f green:137.0f/255.0f blue:148.0f/255.0f] width:screenSize.width height:screenSize.height];
        [self addChild:backgroundLayer];
        
        CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"Make In DylanPan" fontName:@"ArailMT" fontSize:16];
        creditsLabel.position = CGPointMake(creditsLabel.contentSize.width * 0.5f + 20.0f, -creditsLabel.contentSize.height * 0.5f);
        [self addChild:creditsLabel];
        
        _backButton = [CCLabelTTF labelWithString:@"BACK" fontName:@"ArailMT" fontSize:16];
        _backButton.position = CGPointMake(screenSize.width - _backButton.contentSize.width * 0.5f - 20.0f, screenSize.height - _backButton.contentSize.height * 0.5f - 20.0f);
        [self addChild:_backButton];
        
        CCActionMoveTo *labelMoveAction = [CCActionMoveTo actionWithDuration:5.0f position:CGPointMake(creditsLabel.contentSize.width * 0.5f + 20.0f, _backButton.position.y - creditsLabel.contentSize.height * 0.5f - 20.0f)];
        [creditsLabel runAction:labelMoveAction];
    }
    
    return self;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchPos = [touch locationInView:[touch view]];
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:touchPos];
    //NSLog(@"touch pos:%f,%f",touchLocation.x,touchLocation.y);
    CGRect buttonRect = CGRectMake(_backButton.position.x - _backButton.contentSize.width * 0.5f, _backButton.position.y - _backButton.contentSize.height * 0.5f, _backButton.contentSize.width, _backButton.contentSize.height);
    if (CGRectContainsPoint(buttonRect, touchLocation)) {
        //返回game start
        [[CCDirector sharedDirector] popScene];
    }
}

// -----------------------------------------------------------------

@end




























