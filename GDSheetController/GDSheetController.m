//
//  GDSheetViewController.m
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

#import "GDSheetController.h"
#import "GDSheetController_subclass.h"
#import "GDSheetView.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Types

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines & Constants

//Layout
#define DEFAULT_SHEETS_START_FROM_TOP                   10.f
#define DEFAULT_MAX_DISTANCE_BETWEEN_SHEETS             80.f
#define DEFAULT_SHEET_MIN_SCALEFACTOR                   0.99f
#define DEFAULT_SHEET_FULLSCREEN_SCALEFACTOR            1.f
#define DEFAULT_NAVBAR_OVERLAP                          0.9f       
//Defines vertical overlap of each navigation toolbar. Slight hack that prevents rounding errors
//from showing the whitespace between navigation toolbars.
//Can be customized if require more/less packing of navigation toolbars

//Corner radius
#define DEFAULT_SHEET_CORNER_RADIUS                     5.f

//Gestures
#define DEFAULT_SHEET_GESTURE_SCOPE                     GDSheetGestureScope_AllButTap
#define DEFAULT_SHEET_FULLSCREEN_MODE                   GDSheetFullscreenMode_Controller
#define DEFAULT_SHEET_ENABLE_TAPGESTURE                 YES
#define DEFAULT_SHEET_NUMBEROFTAP_REQUIRED              2

//Transitions
#define DEFAULT_SHEET_FULLSCREEN_DISTANCE_THRESHOLD     44.f
#define DEFAULT_SHEET_USER_INTERACTION_INDEFAULTSTATE   NO

//Animations
#define DEFAULT_SHEET_ANIMATIONS_DURATION               0.3f

//Shadows
#define DEFAULT_SHEET_SHADOW_ENABLED                    YES
#define DEFAULT_SHEET_SHADOW_COLOR                      [UIColor blackColor]
#define DEFAULT_SHEET_SHADOW_OFFSET                     CGSizeMake(0, -5)
#define DEFAULT_SHEET_SHADOW_RADIUS                     DEFAULT_SHEET_CORNER_RADIUS
#define DEFAULT_SHEET_SHADOW_OPACITY                    0.6f

NSString * const GDSheetControllerSheetsStartFromTopKey                         = @"GDSheetControllerSheetsStartFromTopKey";
NSString * const GDSheetControllerMaxDistanceBetweenSheetsKey                   = @"GDSheetControllerMaxDistanceBetweenSheetsKey";
NSString * const GDSheetControllerSheetMinScalingFactorKey                      = @"GDSheetControllerSheetMinScalingFactorKey";
NSString * const GDSheetControllerSheetFullscreenScalingFactorKey               = @"GDSheetControllerSheetFullscreenScalingFactorKey";

NSString * const GDSheetControllerSheetCornerRadiusKey                          = @"GDSheetControllerSheetCornerRadiusKey";

NSString * const GDSheetControllerSheetGestureScopeKey                          = @"GDSheetControllerSheetGestureScopeKey";
NSString * const GDSheetControllerSheetFullscreenModeKey                        = @"GDSheetControllerSheetFullscreenModeKey";
NSString * const GDSheetControllerSheetEnableTapGestureKey                      = @"GDSheetControllerSheetEnableTapGestureKey";
NSString * const GDSheetControllerSheetNumberOfTapRequiredKey                   = @"GDSheetControllerSheetNumberOfTapRequiredKey";

NSString * const GDSheetControllerSheetFullscreenDistanceThresholdKey           = @"GDSheetControllerSheetFullscreenDistanceThresholdKey";
NSString * const GDSheetControllerSheetAllowUserInteractionInDefaultStateKey    = @"GDSheetControllerSheetAllowUserInteractionInDefaultStateKey";

NSString * const GDSheetControllerSheetAnimationsDurationKey                    = @"GDSheetControllerSheetAnimationsDurationKey";

NSString * const GDSheetControllerSheetShadowEnabledKey                         = @"GDSheetControllerSheetShadowEnabledKey";
NSString * const GDSheetControllerSheetShadowColorKey                           = @"GDSheetControllerSheetShadowColorKey";
NSString * const GDSheetControllerSheetShadowOffsetKey                          = @"GDSheetControllerSheetShadowOffsetKey";
NSString * const GDSheetControllerSheetShadowRadiusKey                          = @"GDSheetControllerSheetShadowRadiusKey";
NSString * const GDSheetControllerSheetShadowOpacityKey                         = @"GDSheetControllerSheetShadowOpacityKey";

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Interface

@interface GDSheetController () <GDSheetViewDelegate>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Outlets

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Properties

@property (nonatomic, strong) NSMutableArray                        *sheetControllers;
@property (nonatomic, strong) NSMutableDictionary                   *controllerOptions;
@property (nonatomic, assign) NSUInteger                            numberOfSheets;         //<! Needed during init phase
@property (nonatomic, assign) GDSheetState                          controllerState;
@property (nonatomic, assign) CGRect                                savedViewFrame;         //<! Used with GDSheetFullscreenMode_Screen

@property (nonatomic, assign, readwrite) CGFloat                    sheetsStartFromTop;
@property (nonatomic, assign, readwrite) CGFloat                    maxDistanceBetweenSheets;
@property (nonatomic, assign, readwrite) CGFloat                    sheetMinScaleFactor;
@property (nonatomic, assign, readwrite) CGFloat                    sheetFullscreenScaleFactor;

@property (nonatomic, assign, readwrite) CGFloat                    sheetCornerRadius;

@property (nonatomic, assign, readwrite) GDSheetGestureScope        sheetGestureScope;
@property (nonatomic, assign, readwrite) GDSheetFullscreenMode      sheetFullscreenMode;
@property (nonatomic, assign, readwrite) BOOL                       sheetEnableTapGesture;
@property (nonatomic, assign, readwrite) NSUInteger                 sheetNumberOfTapRequired;

@property (nonatomic, assign, readwrite) CGFloat                    sheetFullScreenDistanceThreshold;
@property (nonatomic, assign, readwrite) BOOL                       sheetUserInteractionEnabledInDefaultState;

@property (nonatomic, assign, readwrite) CGFloat                    sheetAnimationsDuration;

@property (nonatomic, assign, readwrite) BOOL                       sheetShadowEnabled;
@property (nonatomic, assign, readwrite) UIColor                    *sheetShadowColor;
@property (nonatomic, assign, readwrite) CGSize                     sheetShadowOffset;
@property (nonatomic, assign, readwrite) CGFloat                    sheetShadowRadius;
@property (nonatomic, assign, readwrite) CGFloat                    sheetShadowOpacity;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation GDEmbeddedControllers

- (id)initWithEmbeddedController:(UIViewController*)embedded
               previewController:(UIViewController*)preview
{
    self = [super init];
    if(self)
    {
        self.embeddedController = embedded;
        self.previewController = preview;
    }
    return self;
}

@end

@implementation GDSheetController

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup & Teardown

-(void)commonInitGDSheetController
{
    self.controllerState = GDSheetState_Default;
    [self addObserver:self forKeyPath:@"controllerState" options:NSKeyValueObservingOptionNew context:nil];
    
    if(!self.controllerOptions)
    {
        self.controllerOptions = [[NSMutableDictionary alloc] init];
    }
    
    if(!self.sheetControllers)
    {
        self.sheetControllers = [[NSMutableArray alloc] init];
    }
    
    if([self respondsToSelector:@selector(preferredStatusBarStyle)] || self.wantsFullScreenLayout)
    {
        //iOS 7 layout support or old fullScreenLayout
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        self.sheetsStartFromTop += statusBarFrame.size.height;    //<! Add status bar size;
    }
}

+ (instancetype)sheetControllerWithControllers:(NSArray *)arrayOfControllers
                                       options:(NSDictionary *)options
{
    return [[GDSheetController alloc] initWithControllers:arrayOfControllers
                                                  options:options];
}

- (id)initWithControllers:(NSArray *)arrayOfControllers
                  options:(NSDictionary *)options
{
    self = [super init];
    if(self)
    {
        //Set view controller frame correctly
        self.view.frame = self.view.bounds;
        
        if(options)
        {
            self.controllerOptions = [options mutableCopy];
        }
        
        [self commonInitGDSheetController];
        [self addControllerSheets:arrayOfControllers];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self commonInitGDSheetController];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInitGDSheetController];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"controllerState"];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Superclass Overrides

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidUnload
{
	// Release any retained subviews of the main view.
    
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Perform custom tasks associated with displaying the view
}

-(void)viewDidDisappear:(BOOL)animated
{
    // Perform additional tasks associated with dismissing or hiding the view
    
    [super viewDidDisappear:animated];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark Handling rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    //Replace sheets relative to orientation
    [self relayoutSheets];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

#pragma mark Embedded controllers state management

- (void)setEmbeddedController:(UIViewController*)embeddedController
                      toState:(GDSheetState)state
{
    return [self setEmbeddedController:embeddedController
                               toState:state
                              animated:YES
                            completion:NULL];
}


- (void)setEmbeddedController:(UIViewController*)embeddedController
                      toState:(GDSheetState)state
                     animated:(BOOL)animated
                   completion:(GDDefaultCompletionHandler)completion
{
    GDSheetView *sheet = [self sheetFromEmbeddedController:embeddedController];
    
    if(sheet)
    {
        [sheet setState:state animated:animated completion:^(GDSheetView *sheet, GDSheetState previousState, BOOL finished)
        {
            if(completion) completion(finished);
        }];
    }
    else
    {
        if(completion) completion(NO);
    }
}

#pragma mark Embedded controllers adding / removing

- (BOOL)addEmbeddedController:(UIViewController*)embeddedController
{
    BOOL addedSuccesfully = (embeddedController != nil);
    
    if(addedSuccesfully)
    {
        UIViewController *embedded = embeddedController;
        UIViewController *preview  = nil;
        
        if([embeddedController isKindOfClass:[GDEmbeddedControllers class]])
        {
            embedded = [(GDEmbeddedControllers*)embeddedController embeddedController];
            preview  = [(GDEmbeddedControllers*)embeddedController previewController];
        }
        
        embedded.sheetController = self;
        
        GDSheetView *view = nil;
        
        if(preview)
        {
            view = [[GDSheetView alloc] initWithEmbeddedController:embedded
                                                 previewController:preview
                                                   sheetController:self];
        }
        else
        {
            view = [[GDSheetView alloc] initWithEmbeddedController:embedded
                                                   sheetController:self];
        }

        view.delegate = self;
        view.top = self.view.bounds.size.height;
        view.currentScalingFactor = [self sheetFullscreenScaleFactor];
        
        [self.sheetControllers addObject:view];
        
        if(preview) [self addChildViewController:preview];
        [self addChildViewController:embeddedController];
        [self.view addSubview:view];
        if(preview) [preview didMoveToParentViewController:self];
        [embeddedController didMoveToParentViewController:self];
        
        [self relayoutSheets];
    }
    
    return addedSuccesfully;
}

- (BOOL)removeEmbeddedController:(UIViewController*)embeddedController
{
    BOOL removedSuccesfully = (embeddedController != nil);
    
    if(removedSuccesfully)
    {
        GDSheetView *sheet = [self sheetFromEmbeddedController:embeddedController];
        removedSuccesfully &= (sheet != nil);
        
        if(removedSuccesfully)
        {
            [self.sheetControllers removeObject:sheet];
            
            [sheet.embeddedViewController willMoveToParentViewController:nil];
            [sheet.embeddedViewController removeFromParentViewController];
            [sheet removeFromSuperview];
            
            [self relayoutSheets];
        }
    }
    
    return removedSuccesfully;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Methods for using as a subclass

- (void)setEmbeddedControllers:(NSArray*)arrayOfControllers
{
    [self setEmbeddedControllers:arrayOfControllers withOptions:nil];
}

- (void)setEmbeddedControllers:(NSArray*)arrayOfControllers withOptions:(NSDictionary*)options
{
    [self removeControllerSheets];
    
    self.controllerOptions = [options mutableCopy];
    [self addControllerSheets:arrayOfControllers];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Options

- (NSDictionary*)options
{
    return (NSDictionary*)self.controllerOptions;
}

#pragma mark -

- (CGFloat)sheetsStartFromTop
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetsStartFromTopKey];
    
    if(!num)
    {
        self.sheetsStartFromTop = DEFAULT_SHEETS_START_FROM_TOP;
        return [self sheetsStartFromTop];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetsStartFromTop:(CGFloat)sheetsStartFromTop
{
    self.controllerOptions[GDSheetControllerSheetsStartFromTopKey] = @(sheetsStartFromTop);
}

#pragma mark -

- (CGFloat)maxDistanceBetweenSheets
{
    NSNumber *num = self.controllerOptions[GDSheetControllerMaxDistanceBetweenSheetsKey];
    
    if(!num)
    {
        self.maxDistanceBetweenSheets = DEFAULT_MAX_DISTANCE_BETWEEN_SHEETS;
        return [self maxDistanceBetweenSheets];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setMaxDistanceBetweenSheets:(CGFloat)maxDistanceBetweenSheets
{
    self.controllerOptions[GDSheetControllerMaxDistanceBetweenSheetsKey] = @(maxDistanceBetweenSheets);
}

#pragma mark -

- (CGFloat)sheetMinScaleFactor
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetMinScalingFactorKey];
    
    if(!num)
    {
        self.sheetMinScaleFactor = DEFAULT_SHEET_MIN_SCALEFACTOR;
        return [self sheetMinScaleFactor];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetMinScaleFactor:(CGFloat)sheetMinScaleFactor
{
    self.controllerOptions[GDSheetControllerSheetMinScalingFactorKey] = @(sheetMinScaleFactor);
}

#pragma mark -

- (CGFloat)sheetFullscreenScaleFactor
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetFullscreenScalingFactorKey];
    
    if(!num)
    {
        self.sheetFullscreenScaleFactor = DEFAULT_SHEET_FULLSCREEN_SCALEFACTOR;
        return [self sheetFullscreenScaleFactor];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetFullscreenScaleFactor:(CGFloat)sheetFullscreenScaleFactor
{
    self.controllerOptions[GDSheetControllerSheetFullscreenScalingFactorKey] = @(sheetFullscreenScaleFactor);
}

#pragma mark -

- (CGFloat)sheetCornerRadius
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetCornerRadiusKey];
    
    if(!num)
    {
        self.sheetCornerRadius = DEFAULT_SHEET_CORNER_RADIUS;
        return [self sheetCornerRadius];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetCornerRadius:(CGFloat)sheetCornerRadius
{
    self.controllerOptions[GDSheetControllerSheetCornerRadiusKey] = @(sheetCornerRadius);
}

#pragma mark -

- (GDSheetGestureScope)sheetGestureScope
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetGestureScopeKey];
    
    if(!num)
    {
        self.sheetGestureScope = DEFAULT_SHEET_GESTURE_SCOPE;
        return [self sheetGestureScope];
    }
    else
    {
        return [num integerValue];
    }
}

- (void)setSheetGestureScope:(GDSheetGestureScope)sheetGestureScope
{
    self.controllerOptions[GDSheetControllerSheetGestureScopeKey] = @(sheetGestureScope);
}

#pragma mark -

- (GDSheetFullscreenMode)sheetFullscreenMode
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetFullscreenModeKey];
    
    if(!num)
    {
        self.sheetFullscreenMode = DEFAULT_SHEET_FULLSCREEN_MODE;
        return [self sheetFullscreenMode];
    }
    else
    {
        return [num integerValue];
    }
}

- (void)setSheetFullscreenMode:(GDSheetFullscreenMode)sheetFullscreenMode
{
    self.controllerOptions[GDSheetControllerSheetFullscreenModeKey] = @(sheetFullscreenMode);
}

#pragma mark -

- (BOOL)sheetEnableTapGesture
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetEnableTapGestureKey];
    
    if(!num)
    {
        self.sheetEnableTapGesture = DEFAULT_SHEET_ENABLE_TAPGESTURE;
        return [self sheetEnableTapGesture];
    }
    else
    {
        return [num boolValue];
    }
}

- (void)setSheetEnableTapGesture:(BOOL)sheetEnableTapGesture
{
    self.controllerOptions[GDSheetControllerSheetEnableTapGestureKey] = @(sheetEnableTapGesture);
}

#pragma mark -

- (NSUInteger)sheetNumberOfTapRequired
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetNumberOfTapRequiredKey];
    
    if(!num)
    {
        self.sheetNumberOfTapRequired = DEFAULT_SHEET_NUMBEROFTAP_REQUIRED;
        return [self sheetNumberOfTapRequired];
    }
    else
    {
        return [num integerValue];
    }
}

- (void)setSheetNumberOfTapRequired:(NSUInteger)sheetNumberOfTapRequired
{
    self.controllerOptions[GDSheetControllerSheetNumberOfTapRequiredKey] = @(sheetNumberOfTapRequired);
}

#pragma mark -

- (CGFloat)sheetFullScreenDistanceThreshold
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetFullscreenDistanceThresholdKey];
    
    if(!num)
    {
        self.sheetFullScreenDistanceThreshold = DEFAULT_SHEET_FULLSCREEN_DISTANCE_THRESHOLD;
        return [self sheetFullScreenDistanceThreshold];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetFullScreenDistanceThreshold:(CGFloat)sheetFullScreenDistanceThreshold
{
    self.controllerOptions[GDSheetControllerSheetFullscreenDistanceThresholdKey] = @(sheetFullScreenDistanceThreshold);
}

#pragma mark -

- (BOOL)sheetUserInteractionEnabledInDefaultState
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetAllowUserInteractionInDefaultStateKey];
    
    if(!num)
    {
        self.sheetUserInteractionEnabledInDefaultState = DEFAULT_SHEET_USER_INTERACTION_INDEFAULTSTATE;
        return [self sheetUserInteractionEnabledInDefaultState];
    }
    else
    {
        return [num boolValue];
    }
}

- (void)setSheetUserInteractionEnabledInDefaultState:(BOOL)sheetUserInteractionEnabledInDefaultState
{
    self.controllerOptions[GDSheetControllerSheetAllowUserInteractionInDefaultStateKey] = @(sheetUserInteractionEnabledInDefaultState);
}

#pragma mark -

- (CGFloat)sheetAnimationsDuration
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetAnimationsDurationKey];
    
    if(!num)
    {
        self.sheetAnimationsDuration = DEFAULT_SHEET_ANIMATIONS_DURATION;
        return [self sheetAnimationsDuration];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetAnimationsDuration:(CGFloat)sheetAnimationsDuration
{
    self.controllerOptions[GDSheetControllerSheetAnimationsDurationKey] = @(sheetAnimationsDuration);
}

#pragma mark -

- (BOOL)sheetShadowEnabled
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetShadowEnabledKey];
    
    if(!num)
    {
        self.sheetShadowEnabled = DEFAULT_SHEET_SHADOW_ENABLED;
        return [self sheetShadowEnabled];
    }
    else
    {
        return [num boolValue];
    }
}

- (void)setSheetShadowEnabled:(BOOL)sheetShadowEnabled
{
    self.controllerOptions[GDSheetControllerSheetShadowEnabledKey] = @(sheetShadowEnabled);
}

#pragma mark -

- (UIColor*)sheetShadowColor
{
    UIColor *color = self.controllerOptions[GDSheetControllerSheetShadowColorKey];
    
    if(!color && [color isKindOfClass:[UIColor class]])
    {
        self.sheetShadowColor = DEFAULT_SHEET_SHADOW_COLOR;
        return [self sheetShadowColor];
    }
    else
    {
        return color;
    }
}

- (void)setSheetShadowColor:(UIColor *)sheetShadowColor
{
    self.controllerOptions[GDSheetControllerSheetShadowColorKey] = sheetShadowColor;
}

#pragma mark -

- (CGSize)sheetShadowOffset
{
    NSValue *value = self.controllerOptions[GDSheetControllerSheetShadowOffsetKey];
    
    if(!value)
    {
        self.sheetShadowOffset = DEFAULT_SHEET_SHADOW_OFFSET;
        return [self sheetShadowOffset];
    }
    else
    {
        return [value CGSizeValue];
    }
}

- (void)setSheetShadowOffset:(CGSize)sheetShadowOffset
{
    self.controllerOptions[GDSheetControllerSheetShadowOffsetKey] = [NSValue valueWithCGSize:sheetShadowOffset];
}

#pragma mark -

- (CGFloat)sheetShadowRadius
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetShadowRadiusKey];
    
    if(!num)
    {
        self.sheetShadowRadius = DEFAULT_SHEET_SHADOW_RADIUS;
        return [self sheetShadowRadius];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetShadowRadius:(CGFloat)sheetShadowRadius
{
    self.controllerOptions[GDSheetControllerSheetShadowRadiusKey] = @(sheetShadowRadius);
}

#pragma mark -

- (CGFloat)sheetShadowOpacity
{
    NSNumber *num = self.controllerOptions[GDSheetControllerSheetShadowOpacityKey];
    
    if(!num)
    {
        self.sheetShadowOpacity = DEFAULT_SHEET_SHADOW_OPACITY;
        return [self sheetShadowOpacity];
    }
    else
    {
        return [num floatValue];
    }
}

- (void)setSheetShadowOpacity:(CGFloat)sheetShadowOpacity
{
    self.controllerOptions[GDSheetControllerSheetShadowOpacityKey] = @(sheetShadowOpacity);
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

#pragma mark Layout Subviews

- (void)zeroingSheets
{
    for(GDSheetView *sheet in self.sheetControllers)
    {
        sheet.top                       = self.view.bounds.size.height;
        sheet.currentScalingFactor      = [self sheetFullscreenScaleFactor];
    }
}

- (void)relayoutSheets
{
    self.numberOfSheets = [self.sheetControllers count];
    
    NSUInteger idx = 0;
    for(GDSheetView *sheet in self.sheetControllers)
    {
        sheet.defaultTopInSuperview  = [self topOriginOfSheetAtIndex:idx];
        
        if(self.controllerState == GDSheetState_Default)
        {
            sheet.top                   = sheet.defaultTopInSuperview;
            sheet.currentScalingFactor  = [self scaleFactorOfSheetAtIndex:idx];
        }
        
        idx++;
    }
}

#pragma mark Add remove sheets methods

- (void)addControllerSheets:(NSArray*)arrayOfControllers
{
    NSUInteger idx = 0;
    
    self.numberOfSheets = [arrayOfControllers count];
    
    for(UIViewController *vc in arrayOfControllers)
    {
        UIViewController *embedded = vc;
        UIViewController *preview  = nil;
        
        if([vc isKindOfClass:[GDEmbeddedControllers class]])
        {
            embedded = [(GDEmbeddedControllers*)vc embeddedController];
            preview  = [(GDEmbeddedControllers*)vc previewController];
        }
        
        embedded.sheetController = self;
        
        GDSheetView *view = nil;
        
        if(preview)
        {
            view = [[GDSheetView alloc] initWithEmbeddedController:embedded
                                                 previewController:preview
                                                   sheetController:self];
        }
        else
        {
            view = [[GDSheetView alloc] initWithEmbeddedController:embedded
                                                   sheetController:self];
        }
        
        view.delegate = self;
        
        [self.sheetControllers addObject:view];

        view.defaultTopInSuperview  = [self topOriginOfSheetAtIndex:idx];
        view.top                    = view.defaultTopInSuperview;
        view.currentScalingFactor   = [self scaleFactorOfSheetAtIndex:idx];
        
        if(preview) [self addChildViewController:preview];
        [self addChildViewController:embedded];
        [self.view addSubview:view];
        if(preview) [preview didMoveToParentViewController:self];
        [embedded didMoveToParentViewController:self];
        
        idx++;
    }
}

- (void)removeControllerSheets
{
    for(GDSheetView *sheet in self.sheetControllers)
    {
        [sheet.embeddedViewController willMoveToParentViewController:nil];
        [sheet.embeddedViewController removeFromParentViewController];
        [sheet removeFromSuperview];
    }
}

#pragma mark Sheets placement methods

- (CGFloat)topOriginOfSheetAtIndex:(NSUInteger)indexOfSheet
{
    //Sum up the shrunken size of each of the cards appearing before the current index
    CGFloat originOffset = 0;
    CGFloat distanceBetweenSheets = (self.view.bounds.size.height - self.sheetsStartFromTop);
    distanceBetweenSheets -= self.sheetFullScreenDistanceThreshold * self.numberOfSheets;
    distanceBetweenSheets = distanceBetweenSheets / (CGFloat)self.numberOfSheets;
    
    for (int i = 0; i < indexOfSheet; i++)
    {
        CGFloat scalingFactor = [self scaleFactorOfSheetAtIndex:i];
        
        originOffset += scalingFactor * self.sheetFullScreenDistanceThreshold * DEFAULT_NAVBAR_OVERLAP;
        originOffset += fminf([self maxDistanceBetweenSheets], distanceBetweenSheets);
    }
    
    //Position should start at self.cardVerticalOrigin and move down by size of nav toolbar for each additional nav controller
    return roundf(self.sheetsStartFromTop + originOffset);
}

- (CGFloat)scaleFactorOfSheetAtIndex:(NSUInteger)indexOfSheet
{
    //Items should get progressively smaller based on their index in the navigation controller array
    return powf(self.sheetMinScaleFactor, (self.numberOfSheets - indexOfSheet));
}

- (void)expandToWindowSize
{
    if(self.sheetFullscreenMode == GDSheetFullscreenMode_Controller) return;
    NSAssert([self isOnWindow], @"Should be on window to expand to window size. This avoid touch issues");
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect frameOnWindow = window.bounds;

    if(![self respondsToSelector:@selector(preferredStatusBarStyle)])
    {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
        frameOnWindow.origin.y = statusBarFrame.size.height;
        frameOnWindow.size.height -= statusBarFrame.size.height;
    }

    self.view.frame = frameOnWindow;
}

- (void)moveToWindow
{
    if(self.sheetFullscreenMode == GDSheetFullscreenMode_Controller) return;
    if([self isOnWindow]) return;
    
    //Move to window to pass thought all elements when swiping
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect windowRect = [self.view.superview convertRect:self.view.frame toView:window];
    
    self.view.frame = windowRect;
    [window addSubview:self.view];
    self.savedViewFrame = windowRect;
}

- (void)moveToParentController
{
    if(self.sheetFullscreenMode == GDSheetFullscreenMode_Controller) return;
    if(![self isOnWindow]) return;
    
    //Move back to view controller by converting position in window to position in controller
    //savedViewFrame contains its original position in window
    CGRect superviewRect = [self.view.superview convertRect:self.savedViewFrame toView:self.parentViewController.view];
    
    self.view.frame = superviewRect;
    [self.view removeFromSuperview];
    [self.parentViewController.view addSubview:self.view];
}

- (BOOL)isOnWindow
{
    return [self.view.superview isKindOfClass:[UIWindow class]];
}

#pragma mark Sheets getting helpers

- (GDSheetView*)sheetFromEmbeddedController:(UIViewController*)embeddedController
{
    GDSheetView *correspondingSheet = nil;
    
    //In case of using GDEmbeddedControllers
    if([embeddedController isKindOfClass:[GDEmbeddedControllers class]])
        embeddedController = ((GDEmbeddedControllers*)embeddedController).embeddedController;
    
    BOOL searchingNavController = [embeddedController isKindOfClass:[UINavigationController class]];

    for(GDSheetView *sheet in self.sheetControllers)
    {
        UIViewController *embController = searchingNavController ? sheet.embeddedViewController : sheet.topEmbeddedViewController;
        
        if([embController isEqual:embeddedController])
        {
            correspondingSheet = sheet;
            break;
        }
    }
    
    return correspondingSheet;
}

- (NSArray*)sheetsAboveSheet:(GDSheetView*)aSheet
{
    NSUInteger indexOfSheet = [self.sheetControllers indexOfObject:aSheet];
    
    __typeof__(self) __weak weakSelf = self;
    
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSUInteger currentIdx = [weakSelf.sheetControllers indexOfObject:evaluatedObject];
        
        return indexOfSheet > currentIdx;
    }];
    
    return [self.sheetControllers filteredArrayUsingPredicate:filter];
}

- (NSArray*)sheetsBelowSheet:(GDSheetView*)aSheet
{
    NSUInteger indexOfSheet = [self.sheetControllers indexOfObject:aSheet];
    
    __typeof__(self) __weak weakSelf = self;
    
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSUInteger currentIdx = [weakSelf.sheetControllers indexOfObject:evaluatedObject];
        
        return indexOfSheet < currentIdx;
    }];
    
    return [self.sheetControllers filteredArrayUsingPredicate:filter];
}

- (NSArray*)sheetsExceptSheet:(GDSheetView*)aSheet
{
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        return evaluatedObject != aSheet;
    }];
    
    return [self.sheetControllers filteredArrayUsingPredicate:filter];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions

////////////////////////////////////////////////////////////////////////////////
#pragma mark - GDSheetViewDelegate methods

- (void)sheet:(GDSheetView *)sheet didUpdatePanPercentage:(CGFloat)percentage
{
    if(sheet.state == GDSheetState_Fullscreen)
    {
        for(GDSheetView *aSheet in [self sheetsAboveSheet:sheet])
        {
            CGFloat top = aSheet.top * percentage;
            aSheet.top = top;
        }
    }
    else if(sheet.state == GDSheetState_Default)
    {
        for(GDSheetView *aSheet in [self sheetsBelowSheet:sheet])
        {
            CGFloat deltaDistance   = sheet.top - sheet.defaultTopInSuperview;
            CGFloat top             = aSheet.defaultTopInSuperview + deltaDistance;
            aSheet.top = top;
        }
    }
}

- (void)sheet:(GDSheetView *)sheet willBeginPanningGesture:(UIPanGestureRecognizer*)gesture
{
    //Disable gestures on other sheets
    for(GDSheetView *aSheet in [self sheetsExceptSheet:sheet])
    {
        aSheet.gesturesEnabled = NO;
    }
    
    [self moveToWindow];
}

- (void)sheet:(GDSheetView *)sheet didEndPanningGesture:(UIPanGestureRecognizer*)gesture
{
    //Enable gestures on other sheets
    for(GDSheetView *aSheet in [self sheetsExceptSheet:sheet])
    {
        aSheet.gesturesEnabled = YES;
    }
}

- (void)sheet:(GDSheetView *)sheet willChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState
{
    if([self.delegate respondsToSelector:@selector(sheetController:willChangeEmbeddedController:toDisplayState:fromDisplayState:)])
    {
        [self.delegate sheetController:self willChangeEmbeddedController:sheet.embeddedViewController toDisplayState:toState fromDisplayState:fromState];
    }
}

- (void)sheet:(GDSheetView *)sheet didChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState
{
    __typeof__(self) __weak weakSelf = self;
    
    GDSheetCompletionHandler completion = ^(GDSheetView *aSheet, GDSheetState previousState, BOOL finished)
    {
        if([weakSelf.delegate respondsToSelector:@selector(sheetController:didChangeEmbeddedController:toDisplayState:fromDisplayState:)])
        {
            [weakSelf.delegate sheetController:weakSelf didChangeEmbeddedController:sheet.embeddedViewController toDisplayState:aSheet.state fromDisplayState:previousState];
        }
    };
    
    if((fromState == GDSheetState_Default) && (toState == GDSheetState_Fullscreen))
    {
        for(GDSheetView *aSheet in [self sheetsAboveSheet:sheet])
            [aSheet setState:GDSheetState_HiddenTop animated:YES completion:completion];
        
        for(GDSheetView *aSheet in [self sheetsBelowSheet:sheet])
            [aSheet setState:GDSheetState_HiddenBottom animated:YES completion:completion];
        
        self.controllerState = GDSheetState_Fullscreen;
        completion(sheet, fromState, YES);
    }
    else if((fromState == GDSheetState_Fullscreen) && (toState == GDSheetState_Default))
    {
        for(GDSheetView *aSheet in [self sheetsAboveSheet:sheet])
            [aSheet setState:GDSheetState_Default animated:YES completion:completion];
        
        for(GDSheetView *aSheet in [self sheetsBelowSheet:sheet])
            [aSheet setState:GDSheetState_Default animated:YES completion:completion];
        
        self.controllerState = GDSheetState_Default;
        completion(sheet, fromState, YES);
    }
    else if((fromState == GDSheetState_Default) && (toState == GDSheetState_Default))
    {
        for(GDSheetView *aSheet in [self sheetsBelowSheet:sheet])
            
            [aSheet setState:GDSheetState_Default animated:YES completion:completion];
        
        self.controllerState = GDSheetState_Default;
        completion(sheet, fromState, YES);
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"controllerState"])
    {
        if(self.controllerState == GDSheetState_Default)
        {
            [self moveToParentController];
        }
        else if(self.controllerState == GDSheetState_Fullscreen)
        {
            if(![self isOnWindow]) [self moveToWindow];     //<! In case of using tap gesture to expand
            [self expandToWindowSize];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
