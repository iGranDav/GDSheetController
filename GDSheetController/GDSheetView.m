//
//  GDSheetView.m
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 22/08/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

/*
 Copyright (c) 2013 David Bonnet (aka iGranDav)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#if ! __has_feature(objc_arc)
#error This file is expected to be compiled with ARC turned ON
#endif

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Imports

#import "GDSheetView.h"
#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Types

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines & Constants

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Interface

@interface GDSheetView () <UIGestureRecognizerDelegate>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Properties

@property (nonatomic, strong) UIPanGestureRecognizer    *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer    *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer    *panPreviewGesture;
@property (nonatomic, strong) UITapGestureRecognizer    *tapPreviewGesture;


@property (nonatomic, assign) CGFloat                   panGestureTopOffset;

//Sheet options
@property (nonatomic, assign) CGFloat                   sheetMinScaleFactor;
@property (nonatomic, assign) CGFloat                   sheetFullscreenScaleFactor;

@property (nonatomic, assign) CGFloat                   sheetCornerRadius;

@property (nonatomic, assign) GDSheetGestureScope       sheetGestureScope;
@property (nonatomic, assign) GDSheetFullscreenMode     sheetFullscreenMode;
@property (nonatomic, assign) BOOL                      sheetEnableTapGesture;
@property (nonatomic, assign) NSUInteger                sheetNumberOfTapRequired;

@property (nonatomic, assign) CGFloat                   fullScreenDistanceThreshold;
@property (nonatomic, assign) BOOL                      sheetUserInteractionEnabledInDefaultState;

@property (nonatomic, assign) CGFloat                   sheetAnimationsDuration;

@property (nonatomic, assign) BOOL                      sheetShadowEnabled;
@property (nonatomic, assign) UIColor                   *sheetShadowColor;
@property (nonatomic, assign) CGSize                    sheetShadowOffset;
@property (nonatomic, assign) CGFloat                   sheetShadowRadius;
@property (nonatomic, assign) CGFloat                   sheetShadowOpacity;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation GDSheetView

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup & Teardown

-(void)commonInitGDSheetView
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                             UIViewAutoresizingFlexibleHeight |
                             UIViewAutoresizingFlexibleLeftMargin |
                             UIViewAutoresizingFlexibleRightMargin |
                             UIViewAutoresizingFlexibleTopMargin |
                             UIViewAutoresizingFlexibleWidth);
    
    if(self.currentScalingFactor == 0.f)    _currentScalingFactor  = self.sheetMinScaleFactor;
    if(self.defaultTopInSuperview == 0.f)   _defaultTopInSuperview = self.top;
    [self setState:GDSheetState_Default animated:NO completion:NULL];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
    self.panGesture.delegate = self;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformTapGesture:)];
    self.tapGesture.numberOfTapsRequired = self.sheetNumberOfTapRequired;
    self.tapGesture.delegate = self;
    
    self.panPreviewGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
    self.panPreviewGesture.delegate = self;
    self.tapPreviewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformTapGesture:)];
    self.tapPreviewGesture.numberOfTapsRequired = self.sheetNumberOfTapRequired;
    self.tapPreviewGesture.delegate = self;
    
    [self addPanGesture:self.panGesture
             tapGesture:self.tapGesture
           onController:self.embeddedViewController];
    
    [self addPanGesture:self.panPreviewGesture
             tapGesture:self.tapPreviewGesture
           onController:self.previewViewController];
}

- (void)configureSheetOptions:(GDSheetController*)sheetController
{
    self.sheetMinScaleFactor                        = [sheetController sheetMinScaleFactor];
    self.sheetFullscreenScaleFactor                 = [sheetController sheetFullscreenScaleFactor];
    self.sheetCornerRadius                          = [sheetController sheetCornerRadius];
    self.sheetGestureScope                          = [sheetController sheetGestureScope];
    self.sheetFullscreenMode                        = [sheetController sheetFullscreenMode];
    self.sheetEnableTapGesture                      = [sheetController sheetEnableTapGesture];
    self.sheetNumberOfTapRequired                   = [sheetController sheetNumberOfTapRequired];
    self.fullScreenDistanceThreshold                = [sheetController sheetFullScreenDistanceThreshold];
    self.sheetUserInteractionEnabledInDefaultState  = [sheetController sheetUserInteractionEnabledInDefaultState];
    self.sheetAnimationsDuration                    = [sheetController sheetAnimationsDuration];
    
    self.sheetShadowEnabled                         = [sheetController sheetShadowEnabled];
    self.sheetShadowColor                           = [sheetController sheetShadowColor];
    self.sheetShadowOffset                          = [sheetController sheetShadowOffset];
    self.sheetShadowRadius                          = [sheetController sheetShadowRadius];
    self.sheetShadowOpacity                         = [sheetController sheetShadowOpacity];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInitGDSheetView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInitGDSheetView];
    }
    return self;
}

- (id)initWithEmbeddedController:(UIViewController*)embeddedController
                 sheetController:(GDSheetController*)sheetController
{
    self = [super initWithFrame:embeddedController.view.bounds];
    if(self)
    {
        [self configureSheetOptions:sheetController];
        
        self.embeddedViewController = embeddedController;
        
        [self commonInitGDSheetView];
    }
    return self;
}

- (id)initWithEmbeddedController:(UIViewController*)embeddedController
               previewController:(UIViewController*)previewController
                 sheetController:(GDSheetController*)sheetController
{
    self = [super initWithFrame:embeddedController.view.bounds];
    if(self)
    {
        [self configureSheetOptions:sheetController];
        
        self.embeddedViewController = embeddedController;
        self.previewViewController = previewController;
        
        [self commonInitGDSheetView];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Superclass Overrides

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self redrawShadowsForRect:[self bounds]];
}

- (void)redrawShadowsForRect:(CGRect)rect
{
    if(self.sheetShadowEnabled && self.state == GDSheetState_Default)
    {
        UIBezierPath *path  =  [UIBezierPath bezierPathWithRoundedRect:rect
                                                          cornerRadius:self.sheetCornerRadius];
        
        [self.layer setShadowOpacity:self.sheetShadowOpacity];
        [self.layer setShadowOffset:self.sheetShadowOffset];
        [self.layer setShadowRadius:self.sheetShadowRadius];
        [self.layer setShadowColor:[self.sheetShadowColor CGColor]];
        [self.layer setShadowPath:[path CGPath]];
    }
    else if(self.sheetShadowEnabled)
    {
        [self.layer setShadowOpacity:self.sheetShadowOpacity];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowRadius:0.f];
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

- (void)setEmbeddedViewController:(UIViewController *)embeddedViewController
{
    [self willChangeValueForKey:@"embeddedViewController"];
    _embeddedViewController = embeddedViewController;
    
    _embeddedViewController.view.layer.cornerRadius = self.sheetCornerRadius;
    _embeddedViewController.view.clipsToBounds = YES;
    
    _embeddedViewController.view.frame = self.bounds;
    [self addSubview:_embeddedViewController.view];
    
    if(_panGesture && _tapGesture)
    {
        [self addPanGesture:self.panGesture
                 tapGesture:self.tapGesture
               onController:_embeddedViewController];
    }
    
    [self didChangeValueForKey:@"embeddedViewController"];
}

- (void)setPreviewViewController:(UIViewController *)previewViewController
{
    [self willChangeValueForKey:@"previewViewController"];
    _previewViewController = previewViewController;
    
    _previewViewController.view.layer.cornerRadius = self.sheetCornerRadius;
    _previewViewController.view.clipsToBounds = YES;
    
    _previewViewController.view.frame = self.bounds;
    [self addSubview:_previewViewController.view];
    [self bringSubviewToFront:_previewViewController.view];
    
    if(_panPreviewGesture && _tapPreviewGesture)
    {
        [self addPanGesture:self.panPreviewGesture
                 tapGesture:self.tapPreviewGesture
               onController:_previewViewController];
    }
    
    [self didChangeValueForKey:@"previewViewController"];
}

- (void)setCurrentScalingFactor:(CGFloat)currentScalingFactor
{
    [self setCurrentScalingFactor:currentScalingFactor animated:NO];
}

- (void)setCurrentScalingFactor:(CGFloat)currentScalingFactor animated:(BOOL)animated
{
    [self willChangeValueForKey:@"currentScalingFactor"];
    _currentScalingFactor = currentScalingFactor;
    
    [self setState:_state animated:animated completion:NULL];
    
    [self didChangeValueForKey:@"currentScalingFactor"];
}

- (BOOL)areGesturesEnabled
{
    return self.panGesture.enabled && self.tapGesture.enabled;
}

- (void)setGesturesEnabled:(BOOL)gesturesEnabled
{
    [self willChangeValueForKey:@"gesturesEnabled"];
    
    self.panGesture.enabled = gesturesEnabled;
    self.tapGesture.enabled = gesturesEnabled;
    
    [self didChangeValueForKey:@"gesturesEnabled"];
}

/**
 *	Gets the embedded controller on top of the embedded navigation controller (if exists)
 *  or the embedded controller itself
 *
 *	@return	the top embedded view controller
 */
- (UIViewController*)topEmbeddedViewController
{
    UIViewController *topController = nil;
    if([self.embeddedViewController isKindOfClass:[UINavigationController class]])
    {
        topController = [(UINavigationController*)self.embeddedViewController topViewController];
    }
    else
    {
        topController = self.embeddedViewController;
    }
    
    return topController;
}

/**
 *	Gets the preview controller on top of the preview navigation controller (if exists)
 *  or the preview controller itself
 *
 *	@return	the top preview view controller
 */
- (UIViewController*)topPreviewViewController
{
    UIViewController *topController = nil;
    if([self.previewViewController isKindOfClass:[UINavigationController class]])
    {
        topController = [(UINavigationController*)self.previewViewController topViewController];
    }
    else
    {
        topController = self.previewViewController;
    }
    
    return topController;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

#pragma mark Gestures helpers

- (void)addPanGesture:(UIPanGestureRecognizer*)panGesture
           tapGesture:(UITapGestureRecognizer*)tapGesture
         onController:(UIViewController*)aController
{
    if(aController)
    {
        UIView *gesturesView = nil;
        
        if ([aController isKindOfClass:[UINavigationController class]]
            && self.sheetGestureScope == GDSheetGestureScope_NavBar)
        {
            gesturesView = [(UINavigationController*)aController navigationBar];
        }
        else
        {
            gesturesView = aController.view;
        }
        
        if(gesturesView)
        {
            //Add pan gesture to view
            [gesturesView addGestureRecognizer:panGesture];
            
            //Add Tap gesture
            if (self.sheetEnableTapGesture)
            {
                if((self.sheetGestureScope != GDSheetGestureScope_AllButTap)
                   || ![aController isKindOfClass:[UINavigationController class]])
                {
                    [gesturesView addGestureRecognizer:tapGesture];
                }
                else
                {
                    [[(UINavigationController*)aController navigationBar] addGestureRecognizer:tapGesture];
                }
            }
        }
    }
}

#pragma mark Data helpers

- (CGFloat)percentageDistanceTravelled {
    return self.frame.origin.y/self.defaultTopInSuperview;
}

- (void)allowUserInteraction:(BOOL)isAllowed
{
    // Apply user interaction only when controllers are embedded in navigation controllers
    // to avoid blocking gestures on simple controllers
    
    //Embedded
    if([self.embeddedViewController isKindOfClass:[UINavigationController class]])
    {
        [[self topEmbeddedViewController].view setUserInteractionEnabled:isAllowed];
    }
    
    //Preview
    if([self.previewViewController isKindOfClass:[UINavigationController class]])
    {
        [[self topPreviewViewController].view setUserInteractionEnabled:isAllowed];
    }
}

#pragma mark UIView helpers

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = roundf(y);
    self.frame = frame;
}

#pragma mark Sheet resizing

- (void)shrinkSheetToScaledSize:(BOOL)animated
{
    [self scaleSheetToFactor:self.currentScalingFactor animated:animated];
}

- (void)expandSheetToFullSize:(BOOL)animated
{
    [self scaleSheetToFactor:self.sheetFullscreenScaleFactor animated:animated];
}

- (void)scaleSheetToFactor:(CGFloat)scaleFactor animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:self.sheetAnimationsDuration
                         animations:^{
                             [self scaleSheetToFactor:scaleFactor animated:NO];
                         }];
    }
    else
    {
        [self setTransform:CGAffineTransformMakeScale(scaleFactor, scaleFactor)];
    }
}

#pragma mark Controllers switching

- (void)switchFromPreviewToEmbeddedController
{
    if(self.previewViewController)
    {
        self.previewViewController.view.alpha = 0.f;
    }
    
    self.embeddedViewController.view.alpha = 1.f;
}

- (void)switchBackToPreviewFromEmbeddedController
{
    if(self.previewViewController)
    {
        self.previewViewController.view.alpha = 1.f;
        self.embeddedViewController.view.alpha = 0.f;
    }
    else
    {
        self.embeddedViewController.view.alpha = 1.f;
    }
}

#pragma mark State handling

- (void)setState:(GDSheetState)state
{
    [self setState:state animated:YES completion:NULL];
}

- (void)setState:(GDSheetState)state animated:(BOOL)animated completion:(GDSheetCompletionHandler)completion
{
    [self setState:state animated:animated fromUser:YES completion:completion];
}

- (void)setState:(GDSheetState)state animated:(BOOL)animated fromUser:(BOOL)fromUser completion:(GDSheetCompletionHandler)completion
{
    GDSheetState previousState = self.state;
    if(fromUser){
        [self notifyStateWillChangedToState:state];
        
        if ([self.delegate respondsToSelector:@selector(sheet:didChangeToDisplayState:fromDisplayState:)]) {
            [self.delegate sheet:self willChangeToDisplayState:state fromDisplayState:previousState];
        }
    }
    
    if (animated) {
        [UIView animateWithDuration:self.sheetAnimationsDuration
                         animations:^{
                             [self setState:state animated:NO fromUser:NO completion:completion];
                         }
                         completion:^(BOOL finished) {
                             if (state == GDSheetState_Fullscreen) {
                                 // Fix scaling bug when expand to full size
                                 self.frame = self.superview.bounds;

                                 if([self respondsToSelector:@selector(motionEffects)])
                                 {
                                     //iOS 7 layout support or old fullScreenLayout
                                     CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                                     [self setTop:statusBarFrame.size.height];
                                 }
                                 
                                 self.embeddedViewController.view.frame              = self.bounds;
                                 self.layer.cornerRadius                             = 3.0;
                                 self.embeddedViewController.view.layer.cornerRadius = 3.0;
                                 
                                 self.previewViewController.view.frame               = self.bounds;
                                 self.layer.cornerRadius                             = 3.0;
                                 self.previewViewController.view.layer.cornerRadius  = 3.0;
                             }
                             
                             if(fromUser)
                             {
                                 [self notifyStateDidChangedFromPreviousState:previousState];
                                 if(completion) completion(self, previousState, finished);
                             }
                         }];
        return;
    }
    
    [self willChangeValueForKey:@"state"];
    
    // Set corner radius
    self.layer.cornerRadius                             = self.sheetCornerRadius;
    self.embeddedViewController.view.layer.cornerRadius = self.sheetCornerRadius;
    self.previewViewController.view.layer.cornerRadius  = self.sheetCornerRadius;
    
    //Full Screen State
    if (state == GDSheetState_Fullscreen)
    {
        [self allowUserInteraction:YES];
        [self expandSheetToFullSize:animated];
        
        [self switchFromPreviewToEmbeddedController];
        
        if([self respondsToSelector:@selector(motionEffects)])
        {
            //iOS 7 layout support or old fullScreenLayout
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [self setTop:statusBarFrame.size.height];
        }
        else
        {
            [self setTop:0.f];
        }
    }
    //Default State
    else if (state == GDSheetState_Default)
    {
        [self allowUserInteraction:self.sheetUserInteractionEnabledInDefaultState];
        [self shrinkSheetToScaledSize:animated];
        [self setTop:self.defaultTopInSuperview];
        
        [self switchBackToPreviewFromEmbeddedController];
    }
    //Hidden State - Bottom
    else if (state == GDSheetState_HiddenBottom)
    {
        //Move it off screen and far enough down that the shadow does not appear on screen
        CGFloat offscreenOrigin = self.superview.frame.size.height + abs(self.sheetShadowOffset.height)*3;
        [self setTop: offscreenOrigin];
        
        [self switchBackToPreviewFromEmbeddedController];
    }
    //Hidden State - Top
    else if (state == GDSheetState_HiddenTop) {
        
        if([self respondsToSelector:@selector(motionEffects)])
        {
            //iOS 7 layout support or old fullScreenLayout
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [self setTop:statusBarFrame.size.height];
        }
        else
        {
            [self setTop:0.f];
        }
        
        [self switchBackToPreviewFromEmbeddedController];
    }
    
    //Update to the new state
    _state = state;
    
    [self didChangeValueForKey:@"state"];
    
    //Do not include this call in the animation loop (when calling it recrusively from animation block)
    if(fromUser)
    {
        [self notifyStateDidChangedFromPreviousState:previousState];
        if(completion) completion(self, previousState, YES);
    }
    
    //Notify the delegate of the state change (even if state changed to self)
    if ([self.delegate respondsToSelector:@selector(sheet:didChangeToDisplayState:fromDisplayState:)]) {
        [self.delegate sheet:self didChangeToDisplayState:self.state fromDisplayState:previousState];
    }
}

//Handle notifications to controllers
- (void)notifyStateWillChangedToState:(GDSheetState)futureState
{
    //Notify the controller
    UIViewController *topController = [self topEmbeddedViewController];
    
    if([topController conformsToProtocol:@protocol(GDSheetEmbeddedController)])
    {
        if([topController respondsToSelector:@selector(embeddedControllerWillChangeToDisplayState:fromDisplayState:)])
        {
            [(UIViewController<GDSheetEmbeddedController>*)topController embeddedControllerWillChangeToDisplayState:futureState
                                                                                                   fromDisplayState:self.state];
        }
    }
}

- (void)notifyStateDidChangedFromPreviousState:(GDSheetState)previousState
{
    //Notify the controller
    UIViewController *topController = [self topEmbeddedViewController];
    
    if([topController conformsToProtocol:@protocol(GDSheetEmbeddedController)])
    {
        if([topController respondsToSelector:@selector(embeddedControllerDidChangeToDisplayState:fromDisplayState:)])
        {
            [(UIViewController<GDSheetEmbeddedController>*)topController embeddedControllerDidChangeToDisplayState:self.state
                                                                                                  fromDisplayState:previousState];
        }
    }
}

- (void)toggleStateAnimated:(BOOL)animated
{
    [self toggleStateAnimated:animated completion:NULL];
}

/**
 *	Switch from Fullscreen to default and in return.
 *
 *	@param	animated	Animate changes
 *  @param  completion  Called after state change and animation block completion
 */
- (void)toggleStateAnimated:(BOOL)animated completion:(GDSheetCompletionHandler)completion
{
    GDSheetState nextState = self.state == GDSheetState_Default ? GDSheetState_Fullscreen : GDSheetState_Default;
    [self setState:nextState animated:animated completion:completion];
}

- (BOOL)shouldReturnToState:(GDSheetState)state fromPoint:(CGPoint)point
{
    if (state == GDSheetState_Fullscreen)
    {
        return ABS(point.y) < self.fullScreenDistanceThreshold;
    }
    else if (state == GDSheetState_Default)
    {
        return point.y > - self.fullScreenDistanceThreshold;
    }
    return NO;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIGestureRecognizer Actions methods

-(void) didPerformTapGesture:(UITapGestureRecognizer*) recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //Toggle State
        [self toggleStateAnimated:YES];
    }
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer {
    CGPoint location = [recognizer locationInView:self.superview];
    CGPoint translation = [recognizer translationInView: self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.delegate respondsToSelector:@selector(sheet:willBeginPanningGesture:)]) {
            [self.delegate sheet:self willBeginPanningGesture:recognizer];
        }
        
        //Begin animation
        if (self.state == GDSheetState_Fullscreen) {
            //Shrink to regular size
            [self shrinkSheetToScaledSize:YES];
        }
        
        //Save the offet to add to the height
        self.panGestureTopOffset = [recognizer locationInView:self].y;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        //Check if panning downwards and move other cards
        if (translation.y > 0){
            
            //Panning downwards from Full screen state
            if (self.state == GDSheetState_Fullscreen && self.frame.origin.y < self.defaultTopInSuperview)
            {
                //Notify delegate so it can update the coordinates of the other cards unless user has travelled past the origin y coordinate
                if ([self.delegate respondsToSelector:@selector(sheet:didUpdatePanPercentage:)])
                {
                    [self.delegate sheet:self didUpdatePanPercentage:[self percentageDistanceTravelled]];
                }
            }
            //Panning downwards from default state
            else if (self.state == GDSheetState_Default && self.frame.origin.y > self.defaultTopInSuperview)
            {
                //Implements behavior such that when originating at the default position and scrolling down, all other cards below the scrolling card move down at the same rate
                if ([self.delegate respondsToSelector:@selector(sheet:didUpdatePanPercentage:)])
                {
                    [self.delegate sheet:self didUpdatePanPercentage:[self percentageDistanceTravelled]];
                }
            }
        }
        else if(self.state == GDSheetState_Fullscreen)
        {
            return;     //<! Do not track finger movement when pannig upwards in fullscreen mode
        }
        
        //Track the movement of the users finger during the swipe gesture
        [self setTop: location.y - self.panGestureTopOffset];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(sheet:didEndPanningGesture:)])
        {
            [self.delegate sheet:self
            didEndPanningGesture:recognizer];
        }
        
        //Check if it should return to the origin location
        if ([self shouldReturnToState:self.state fromPoint:[recognizer translationInView:self]])
        {
            [self setState:self.state animated:YES completion:NULL];
        }
        else
        {
            //Toggle state between full screen and default if it doesnt return to the current state
            [self toggleStateAnimated:YES];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return ![gestureRecognizer isEqual:self.panGesture];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = YES;
    
    if([gestureRecognizer isEqual:self.panGesture])
    {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView: self];
        
        //Don't begin pan gesture on fullscreen controller if moving upward
        shouldBegin = !(self.state == GDSheetState_Fullscreen && translation.y < 0);
    }
    
    return shouldBegin;
}

@end
