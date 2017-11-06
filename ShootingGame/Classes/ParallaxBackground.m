//
//  ParallaxBackground.m
//
//  Created by : 潘安宇
//  Project    : ShootingGame
//  Date       : 2017/10/11
//
//  Copyright (c) 2017年 潘安宇.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "ParallaxBackground.h"
#import "CCTextureCache.h"
#import "GameScene.h"
#import "checkDeviceConfig.h"

// -----------------------------------------------------------------

@implementation ParallaxBackground

// -----------------------------------------------------------------

+ (instancetype)node
{
    //return [[[self alloc] init] autorelease];
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    if (self) {
        //获取当前屏幕尺寸大小
        _screenSize = [[CCDirector sharedDirector] viewSize];
        
        //添加纹理图片集，在gamescene中已经加载过，这里直接从缓存中取
        //CCTexture *gameArtTexture = [[CCTextureCache sharedTextureCache] addImage:@"game-art.png"];
        
        //添加纹理集到batch node中，3.1版本之后不需要在先放置在batch node中先行进行渲染，直接放置各自的texture，注意z-value的先后
        //CCSprite *backgroundSpriteBatch = [CCSprite spriteWithTexture:gameArtTexture];
        
        _numStripes = 7;
        NSString *bgName = [NSString stringWithFormat:@"iphone5-bg"];
//        NSString *iphoneVersion = [checkDeviceConfig deviceVersionInSimulator];
//        if ([iphoneVersion isEqualToString:@"iPhone 5"]) {
//            bgName = [NSString stringWithFormat:@"iphone5-bg"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 5s"]){
//            bgName = [NSString stringWithFormat:@"iphone5-bg"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 5c"]){
//            bgName = [NSString stringWithFormat:@"iphone5-bg"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 6"]){
//            bgName = [NSString stringWithFormat:@"iphone7-bg"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 7"]){
//            bgName = [NSString stringWithFormat:@"iphone7-bg"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 6 Plus"]){
//            bgName = [NSString stringWithFormat:@"iphone7p-bg"];
//        }else if ([iphoneVersion isEqualToString:@"iPhone 7 Plus"]){
//            bgName = [NSString stringWithFormat:@"iphone7p-bg"];
//        }
        
        //添加7种不同的背景条纹
        for (NSInteger i = 0; i < _numStripes; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%ld.png",bgName,(long)i];
            CCSprite *sprite = [CCSprite spriteWithImageNamed:imageName];
            sprite.anchorPoint = CGPointMake(0.0f, 0.5f);
            sprite.position = CGPointMake(0.0f, _screenSize.height / 2.0f);
            [self addChild:sprite z:i name:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        
        //添加另外一组7种不同的背景条纹，在屏幕外首尾相连，达成无限循环滚屏效果
        for (NSInteger i = 0; i < _numStripes; i++) {
            //需补充iPhone版本判断
            NSString *imageName = [NSString stringWithFormat:@"%@%ld.png",bgName,(long)i];
            CCSprite *sprite = [CCSprite spriteWithImageNamed:imageName];
            sprite.anchorPoint = CGPointMake(0.0f, 0.5f);
            
            //减1是为了消除首尾相连之间的间隙，达到无缝连接的效果
            sprite.position = CGPointMake(_screenSize.width - 1, _screenSize.height / 2.0f);
            
            //使背景形成镜像对称才能首尾相连
            sprite.flipX = YES;
            
            [self addChild:sprite z:i name:[NSString stringWithFormat:@"%ld",(long)(i+_numStripes)]];
        }
        
        //_speedFactors = [[[NSMutableArray alloc] initWithCapacity:_numStripes] autorelease];
        _speedFactors = [[NSMutableArray alloc] initWithCapacity:_numStripes];
        [_speedFactors addObject:[NSNumber numberWithFloat:0.3f]];
        [_speedFactors addObject:[NSNumber numberWithFloat:0.5f]];
        [_speedFactors addObject:[NSNumber numberWithFloat:0.5f]];
        [_speedFactors addObject:[NSNumber numberWithFloat:0.8f]];
        [_speedFactors addObject:[NSNumber numberWithFloat:0.8f]];
        [_speedFactors addObject:[NSNumber numberWithFloat:1.2f]];
        [_speedFactors addObject:[NSNumber numberWithFloat:1.2f]];
        NSAssert([_speedFactors count] == _numStripes, @"speedFactors count does not match numStripes");
        
        _scrollSpeed = 1.0f;
    }
    
    return self;
}

//- (void)dealloc{
//    [_speedFactors release];
//    [super dealloc];
//}

- (void)update:(CCTime)delta{
    NSArray *childrenOfSpriteBatch = [self children];
    for (CCSprite *sprite in childrenOfSpriteBatch) {
        NSNumber *factor = [_speedFactors objectAtIndex:sprite.zOrder];
        
        CGPoint pos = sprite.position;
        pos.x -= _scrollSpeed * [factor floatValue];
        
        if (pos.x < -_screenSize.width) {
            pos.x += (_screenSize.width * 2) - 2;
        }
        sprite.position = pos;
    }
}
// -----------------------------------------------------------------

@end




