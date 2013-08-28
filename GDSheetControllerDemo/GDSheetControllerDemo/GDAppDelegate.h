//
//  GDAppDelegate.h
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 22/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDSheetController;

@interface GDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) GDSheetController         *sheetController;

@end
