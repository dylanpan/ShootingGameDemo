//
//  checkDeviceConfig.m
//  ShootingGame
//
//  Created by 潘安宇 on 2017/10/13.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import "checkDeviceConfig.h"

@implementation checkDeviceConfig

+ (NSString *)deviceVersion{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,3"]) {
        return @"iPhone 5c";
    }
    if ([deviceString isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c";
    }
    if ([deviceString isEqualToString:@"iPhone6,1"]) {
        return @"iPhone 5s";
    }
    if ([deviceString isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5s";
    }
    if ([deviceString isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    }
    if ([deviceString isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    }
    if ([deviceString isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus";
    }
    if ([deviceString isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    }
    if ([deviceString isEqualToString:@"iPhone9,1"]) {
        return @"iPhone 7";
    }
    if ([deviceString isEqualToString:@"iPhone9,2"]) {
        return @"iPhone 7 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,1"]) {
        return @"iPhone 8";
    }
    if ([deviceString isEqualToString:@"iPhone10,4"]) {
        return @"iPhone 8";
    }
    if ([deviceString isEqualToString:@"iPhone10,2"]) {
        return @"iPhone 8 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,5"]) {
        return @"iPhone 8 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,3"]) {
        return @"iPhone X";
    }
    if ([deviceString isEqualToString:@"iPhone10,6"]) {
        return @"iPhone X";
    }
    return deviceString;
}

+ (NSString *)deviceVersionInSimulator{
    CGFloat deviceWidth = [[UIScreen mainScreen] currentMode].size.height;
    if (deviceWidth == 1136) {
        return @"iPhone 5s";
    }else if (deviceWidth == 1334){
        return @"iPhone 7";
    }else if (deviceWidth == 1704){
        return @"iPhone 7 Plus";
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return deviceString;
}

@end
