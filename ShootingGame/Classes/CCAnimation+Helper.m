//
//  CCAnimation+Helper.m
//  ShootingGame
//
//  Created by 潘安宇 on 2017/10/11.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import "CCAnimation+Helper.h"
#import "CCTextureCache.h"

@implementation CCAnimation (Helper)

//通过单个文件创建动画，需要单个文件图片
+ (CCAnimation *)animationWithFile:(NSString *)fileName frameCount:(NSInteger)frameCount delay:(float)delay{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameCount];
    for (NSInteger i = 0; i < frameCount; i++) {
        //通过图片名字获取纹理
        NSString *file = [NSString stringWithFormat:@"%@%ld.png",fileName,(long)i];
        CCTexture *texture = [[CCTextureCache sharedTextureCache] addImage:file];
        
        //通过纹理获取动画（精灵帧）
        CGSize textureSize = [texture contentSize];
        CGRect textureRect = CGRectMake(0.0f, 0.0f, textureSize.width, textureSize.height);
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rectInPixels:textureRect rotated:NO offset:CGPointZero originalSize:textureSize];
        
        [frames addObject:frame];
    }
    
    //通过所有的精灵帧创建动画
    return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}

//通过精灵帧创建动画，需要有纹理集图片和其相应的plist文件
+ (CCAnimation *)animationWithFrame:(NSString *)frameName frameCount:(NSInteger)frameCount delay:(float)delay{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameCount];
    for (NSInteger i = 0; i < frameCount; i++) {
        NSString *file = [NSString stringWithFormat:@"%@%ld.png",frameName,(long)i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
        [frames addObject:frame];
    }
    
    return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}

@end
