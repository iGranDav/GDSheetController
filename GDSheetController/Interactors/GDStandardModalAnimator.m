//
//  GDStandardModalAnimator.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 04/11/2013.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Imports

#import "GDStandardModalAnimator.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Interface

@interface GDStandardModalAnimator ()

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Properties

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation GDStandardModalAnimator

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup & Teardown

-(id)initWithPresenting:(BOOL)presenting
{
    self = [super init];
    if (self)
    {
        self.presenting = presenting;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

// This method can only be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //Get content
    UIViewController *fVC       = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tVC       = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fView               = [fVC view];
    UIView *tView               = [tVC view];
    
    UIView *cView               = [transitionContext containerView];
    
    if(self.presenting)
    {
        //Present animation
        CGRect startFrame           = [transitionContext initialFrameForViewController:tVC];
        CGRect endFrame             = [transitionContext finalFrameForViewController:tVC];
        
        fView.userInteractionEnabled = NO;
        
        [cView addSubview:fView];
        [cView addSubview:tView];
        
        tView.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^
        {
            tView.frame = endFrame;
        }
                         completion:^(BOOL finished)
        {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        //Dismiss animation
        CGRect endFrame             = [transitionContext finalFrameForViewController:fVC];
        
        tView.userInteractionEnabled = YES;
        
        [cView addSubview:tView];
        [cView addSubview:fView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             fView.frame = endFrame;
         }
                         completion:^(BOOL finished)
         {
             [transitionContext completeTransition:YES];
         }];
    }
}

@end
