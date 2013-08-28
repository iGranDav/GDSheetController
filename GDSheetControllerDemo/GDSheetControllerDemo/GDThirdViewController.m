//
//  GDThirdViewController.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 23/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDThirdViewController.h"

@interface GDThirdViewController ()

@end

@implementation GDThirdViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Third";
    self.contentLabel.text = @"Third fully content";
    [self.contentLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
