//
//  GDMainViewController.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 23/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDMainViewController.h"

@interface GDMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *cellsTitle;

@end

@implementation GDMainViewController

- (id)init
{
    self = [super initWithNibName:@"GDMainViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cellsTitle = @[@"Test cell", @"Another content", @"Working great!", @"Isn't it?"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions

- (void)backAction:(id)sender
{
    __typeof__(self) __weak weakSelf = self;
    
    [self.navigationController.sheetController setEmbeddedController:self
                                                             toState:GDSheetState_Default
                                                            animated:YES
                                                          completion:^(BOOL finished) {
                                                              
                                                              NSLog(@"[%@] Back to default", NSStringFromClass([weakSelf class]));
                                                          }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - GDSheetEmbeddedController protocol

- (void)embeddedControllerWillChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState
{
    NSLog(@"    [%@] Will change from %i to %i", NSStringFromClass([self class]), fromState, toState);
    
    if(toState == GDSheetState_Default)
    {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

- (void)embeddedControllerDidChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState
{
    NSLog(@"    [%@] Did change from %i to %i", NSStringFromClass([self class]), fromState, toState);
    
    if(toState == GDSheetState_Fullscreen)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
        [self.navigationItem setLeftBarButtonItem:backButton animated:YES];
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate protocol

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellsTitle count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.cellsTitle[indexPath.row];
    
    return cell;
}

@end
