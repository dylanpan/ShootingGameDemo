//
//  checkDeviceConfig.h
//  ShootingGame
//
//  Created by 潘安宇 on 2017/10/13.
//  Copyright © 2017年 潘安宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface checkDeviceConfig : NSObject

+ (NSString *)deviceVersion;
+ (NSString *)deviceVersionInSimulator;
@end
