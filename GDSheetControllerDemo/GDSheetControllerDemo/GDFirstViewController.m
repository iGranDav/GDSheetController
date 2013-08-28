//
//  GDFirstViewController.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 23/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDFirstViewController.h"

@interface GDFirstViewController ()

@end

@implementation GDFirstViewController

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
    
    self.title = @"First";
    self.contentLabel.text = @"First fully content";
    [self.contentLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
