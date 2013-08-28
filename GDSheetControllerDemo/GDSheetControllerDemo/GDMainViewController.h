//
//  GDMainViewController.h
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 23/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDSheetController.h"

@interface GDMainViewController : UIViewController <GDSheetEmbeddedController>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
