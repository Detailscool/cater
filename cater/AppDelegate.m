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
    
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = _navigationController;
    
    [self.window setBackgroundColor:kGlobalBackgroundColor];
    [self.window makeKeyAndVisible];
    return YES;
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
