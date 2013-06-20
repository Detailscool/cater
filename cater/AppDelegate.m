//
//  AppDelegate.m
//  cater
//
//  Created by jnc on 13-5-30.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDataManager.h"
#import "WebController.h"
#import "sys/utsname.h"
#import "NSString+Strong.h"
#import "RootController.h"
@implementation AppDelegate
@synthesize navigationController = _navigationController;
@synthesize window = _window;
- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    //判断是iphone3,3s,4,4s还是5,5s,如果是5以上的设备 调整界面的位置
    NSString *deviceString = [self deviceString];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = _navigationController;
   
    [self.window makeKeyAndVisible];
    if (![deviceString contains:@"4"] && ![deviceString contains:@"3"]) {
//        CGRect frame = self.window.frame;
//        self.window.frame = CGRectMake(ZERO, 80, frame.size.width, 480);
//        self.navigationController.view.frame = CGRectMake(ZERO, ZERO, frame.size.width, 480);
//        NSLog(@"self.window.frame = %@",NSStringFromCGRect(self.window.frame));
    }
     [self.window setBackgroundColor:[UIColor blackColor]];
    return YES;
}
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [UserDataManager free];
    [WebController free];
}

@end
