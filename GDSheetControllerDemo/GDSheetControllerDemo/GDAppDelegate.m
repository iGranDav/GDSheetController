//
//  GDAppDelegate.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 22/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDAppDelegate.h"
#import "GDSheetController.h"

#import "GDFirstViewController.h"
#import "GDSecondViewController.h"
#import "GDThirdViewController.h"
#import "GDFourthViewController.h"

@implementation GDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    GDFirstViewController   *fVC = [GDFirstViewController new];
    GDSecondViewController  *sVC = [GDSecondViewController new];
    GDThirdViewController   *tVC = [GDThirdViewController new];
    GDFourthViewController  *qVC = [GDFourthViewController new];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fVC];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:sVC];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:tVC];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:qVC];
    
//    NSDictionary *options = @{GDSheetControllerSheetAllowUserInteractionInDefaultStateKey:@YES};
    
    self.sheetController = [[GDSheetController alloc] initWithControllers:@[nav1, nav2, nav3, nav4]
                                                                  options:nil];
//    self.sheetController.wantsFullScreenLayout = YES;
    self.window.rootViewController = self.sheetController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
