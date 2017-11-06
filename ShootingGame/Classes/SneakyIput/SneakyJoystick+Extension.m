//
//  SneakyJoystick+Extension.m
//  ShootingGame
//
//  Created by 潘安宇 on 2017/10/12.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import "SneakyJoystick+Extension.h"

@implementation SneakyJoystick (Extension)

+ (id)joystickWithRect:(CGRect)rect{
    //return [[[SneakyJoystick alloc] initWithRect:rect] autorelease];
    return [[SneakyJoystick alloc] initWithRect:rect];
}

@end
