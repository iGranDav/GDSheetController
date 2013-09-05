//
//  GDAddRemoveSheetViewController.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 04/09/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDAddRemoveSheetViewController.h"
#import "GDSheetController_subclass.h"

#import "GDMainViewController.h"
#import "GDFirstViewController.h"
#import "GDSecondViewController.h"
#import "GDThirdViewController.h"
#import "GDFourthViewController.h"

@interface GDAddRemoveSheetViewController ()

@property (nonatomic, strong) NSMutableArray    *controllers;

@end

@implementation GDAddRemoveSheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.controllers = [[NSMutableArray alloc] init];   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GDFirstViewController   *fVC = [GDFirstViewController new];
    GDSecondViewController  *sVC = [GDSecondViewController new];
    GDThirdViewController   *tVC = [GDThirdViewController new];
    GDFourthViewController  *qVC = [GDFourthViewController new];
    
    [self.controllers addObjectsFromArray:@[fVC, sVC, tVC, qVC]];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fVC];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:sVC];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:tVC];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:qVC];
    
    [self setEmbeddedControllers:@[nav1, nav2, nav3, nav4]
                     withOptions:@{GDSheetControllerSheetsStartFromTopKey:@(70)}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addSheet:(id)sender {
    GDMainViewController  *vc = [GDMainViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.controllers addObject:vc];
    
    [self addEmbeddedController:nav];
}

- (IBAction)removeSheet:(id)sender {
    
    UIViewController *aController = [self.controllers lastObject];
    [self.controllers removeObject:aController];
    
    [self removeEmbeddedController:aController];
}

@end
