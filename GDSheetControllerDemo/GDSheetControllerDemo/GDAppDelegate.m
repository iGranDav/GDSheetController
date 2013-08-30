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

#define DEMO_MODE_ASROOT        0
#define DEMO_MODE_EMBEDDED      1

#define DEMO_MODE               DEMO_MODE_ASROOT            //<! Choose your demo mode here

@interface GDAppDelegate () <GDSheetControllerDelegate>

@end

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
    
#if DEMO_MODE == DEMO_MODE_EMBEDDED
    
    /**
     *  You can add options to your sheetController by using all keys declared in GDSheetController header
     *  This is optionnal. All default values are used instead
     */
    NSDictionary *options = @{GDSheetControllerSheetFullscreenModeKey:@(GDSheetFullscreenMode_Screen)};
    
    self.sheetController = [GDSheetController sheetControllerWithControllers:@[nav1, nav2, nav3, nav4]
                                                                     options:options];
    self.sheetController.delegate = self;
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"Embedded Sheet Test";
    vc.view.backgroundColor = [UIColor blueColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [vc addChildViewController:self.sheetController];
    [vc.view addSubview:self.sheetController.view];
    [self.sheetController didMoveToParentViewController:vc];
    
#else
    
    self.sheetController = [GDSheetController sheetControllerWithControllers:@[nav1, nav2, nav3, nav4]
                                                                     options:nil];
    self.sheetController.delegate = self;
    
    self.window.rootViewController = self.sheetController;
    [self.window makeKeyAndVisible];
    
#endif
    
    
    
    return YES;
}

- (void)sheetController:(GDSheetController *)controller
willChangeEmbeddedController:(UIViewController*)embeddedController
         toDisplayState:(GDSheetState)toState
       fromDisplayState:(GDSheetState)fromState
{
    NSLog(@"[%@] Embedded %@ will change from %i to %i", NSStringFromClass([controller class]), NSStringFromClass([embeddedController class]), fromState, toState);
}

- (void)sheetController:(GDSheetController *)controller
didChangeEmbeddedController:(UIViewController*)embeddedController
         toDisplayState:(GDSheetState)toState
       fromDisplayState:(GDSheetState)fromState
{
    NSLog(@"[%@] Embedded %@ did change from %i to %i", NSStringFromClass([controller class]), NSStringFromClass([embeddedController class]), fromState, toState);
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
