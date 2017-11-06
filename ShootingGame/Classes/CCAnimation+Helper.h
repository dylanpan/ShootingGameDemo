//
//  CCAnimation+Helper.h
//  ShootingGame
//
//  Created by 潘安宇 on 2017/10/11.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import "CCAnimation.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCAnimation (Helper)

+ (CCAnimation *)animationWithFile:(NSString *)fileName frameCount:(NSInteger)frameCount delay:(float)delay;
+ (CCAnimation *)animationWithFrame:(NSString *)frameName frameCount:(NSInteger)frameCount delay:(float)delay;

@end
