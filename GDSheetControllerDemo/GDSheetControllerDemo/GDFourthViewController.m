//
//  GDFouthViewController.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 26/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDFourthViewController.h"

@interface GDFourthViewController ()

@end

@implementation GDFourthViewController

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
    
    self.title = @"Fourth";
    self.contentLabel.text = @"Fourth fully content";
    [self.contentLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
