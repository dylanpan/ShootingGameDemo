//
//  SneakyButton+Extension.m
//  ShootingGame
//
//  Created by 潘安宇 on 2017/10/11.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import "SneakyButton+Extension.h"

@implementation SneakyButton (Extension)

+ (id)button{
    //return [[[SneakyButton alloc] initWithRect:CGRectZero] autorelease];
    //return [[SneakyButton alloc] initWithRect:CGRectZero];
    return [[SneakyButton alloc] initWithRect:CGRectMake(0.0f, 0.0f, 150.0f, 150.0f)];
}

+ (id)buttonWithRect:(CGRect)rect{
    //return [[[SneakyButton alloc] initWithRect:rect] autorelease];
    return [[SneakyButton alloc] initWithRect:rect];
}

@end
