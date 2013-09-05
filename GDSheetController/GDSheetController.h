//
//  GDSheetViewController.h
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

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Imports

#import <UIKit/UIKit.h>
#import "UIViewController+GDSheetController.h"

/**
 *	GDEmbeddedControllers is an object encapsulating a sheet's embedded
 *  controller and its preview controller.
 *
 *  @note You can use it with all existing methods on GDSheetController, and you
 *        can also mix this object with other regular view controllers if
 *        you don't want to have preview for all your sheets
 */
@interface GDEmbeddedControllers : UIViewController

@property (nonatomic, strong) UIViewController *embeddedController;
@property (nonatomic, strong) UIViewController *previewController;

- (id)initWithEmbeddedController:(UIViewController*)embedded
               previewController:(UIViewController*)preview;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Types

typedef NS_ENUM(NSUInteger, GDSheetFullscreenMode)
{
    GDSheetFullscreenMode_Controller,                   //<! Sheet go fullscreen inside the sheet controller only! (default)
    GDSheetFullscreenMode_Screen                        //<! Sheet go fullscreen on the whole screen (current keyWindow) and go outside the sheet controller
};

typedef NS_ENUM(NSUInteger, GDSheetGestureScope)
{
    GDSheetGestureScope_NavBar,                         //<! Sheet gestures only works from the navigation bar if available
    GDSheetGestureScope_AllButTap,                      //<! Sheet pan gesture works on the whole sheet and tap gesture only from the navigation bar if available (default)
    GDSheetGestureScope_All                             //<! Sheet gestures works on the whole sheet (default when no navigation controller on sheet)
};

typedef NS_OPTIONS(NSUInteger, GDSheetState)
{
    GDSheetState_Default        = 0,                                                        //<! Default sheet location
    GDSheetState_Fullscreen     = 1,                                                        //<! Sheet is fullscreen
    GDSheetState_HiddenBottom   = 2 << 0,                                                   //<! Sheet is hidden (below bottom of visible area)
    GDSheetState_HiddenTop      = 2 << 1,                                                   //<! Sheet is hidden (at top of visible area)
    GDSheetState_Hidden         = (GDSheetState_HiddenBottom | GDSheetState_HiddenTop)      //<! Sheet is hidden
};

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines & Constants

typedef void(^GDDefaultCompletionHandler)(BOOL finished);
typedef void(^GDDefaultErrorHandler)(NSError *error);

#pragma mark Sheet options key

/**
 * Determines the distance from the top that sheets stack starts.
 * Making this value larger / smaller will make the sheets shift down/up
 *
 * @default 10.f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetsStartFromTopKey;

/**
 * Determines the max distance between sheets to show embedded controller
 * content when sheets are closed
 *
 * @default 70.f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerMaxDistanceBetweenSheetsKey;

/**
 * Determines the amount to shrink each sheet from the previous one
 *
 * @default 0.98f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetMinScalingFactorKey;

/**
 * Determines the fullscreen sheet scale factor
 *
 * @default 1.f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetFullscreenScalingFactorKey;

/**
 * Determines the sheets corner radius to apply
 *
 * @default 5.f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetCornerRadiusKey;

/**
 * Determines the UIPanGestureRecognizer and UITapGestureRecognizer scope over the sheet.
 *
 * When using GDSheetGestureScope_NavBar the gestures are available only on the
 * navigation bar if your controller is embedded in a navigation controller.
 * Overwise GDSheetGestureScope_All is performed.
 *
 * @default GDSheetGestureScope_AllButTap
 * @value NSNumber containing a GDSheetGestureScope value
 */
extern NSString * const GDSheetControllerSheetGestureScopeKey;

/**
 * Determines the sheets fullscreen mode
 *
 * @default GDSheetFullscreenMode_Controller
 * @value NSNumber containing a GDSheetFullscreenMode value
 */
extern NSString * const GDSheetControllerSheetFullscreenModeKey;

/**
 * Determines whether there's a UITapGestureRecognizer placed over the entire
 * sheet, to enable toogle-fullscreen functionnality.
 *
 * @default YES
 * @value NSNumber containing BOOL
 */
extern NSString * const GDSheetControllerSheetEnableTapGestureKey;

/**
 * Determines the number of tap required for the UITapGestureRecognizer placed on
 * sheet.
 *
 * @default 2
 * @value NSNumber containing NSUInteger
 */
extern NSString * const GDSheetControllerSheetNumberOfTapRequiredKey;

/**
 * Determines the distance threshold in points to pass before switching sheet' state
 *
 * @default 44.f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetFullscreenDistanceThresholdKey;

/**
 * Determines if the user can interract with sheet content when sheet is in default state
 *
 * @default NO
 * @value NSNumber containing BOOL
 */
extern NSString * const GDSheetControllerSheetAllowUserInteractionInDefaultStateKey;

/**
 * Determines the sheets animations duration
 *
 * @default 0.3f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetAnimationsDurationKey;

/**
 * Determines the sheets shadow are enabled
 * Disabling shadows greatly improve performance and fluidity of animations
 *
 * @default YES
 * @value NSNumber containing BOOL
 */
extern NSString * const GDSheetControllerSheetShadowEnabledKey;

/**
 * Determines the sheets shadow color
 *
 * @default [UIColor blackColor]
 * @value UIColor
 */
extern NSString * const GDSheetControllerSheetShadowColorKey;

/**
 * Determines the sheets shadow offset
 *
 * @default (0, -5)
 * @value NSValue containing CGSize
 */
extern NSString * const GDSheetControllerSheetShadowOffsetKey;

/**
 * Determines the sheets shadow radius
 *
 * @default default value of GDSheetControllerSheetCornerRadiusKey (aka 5.f)
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetShadowRadiusKey;

/**
 * Determines the sheets shadow opacity
 *
 * @default 0.6f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerSheetShadowOpacityKey;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Protocols

/**
 *	Embedded controllers can implement this protocol to be informed of changes
 *  and provide some specific changes
 *
 *  If your controller is inside a navigation controller, GDSheetController will foward all
 *  messages to your controller implementing this protocol
 */
@protocol GDSheetEmbeddedController <NSObject>
@optional

- (void)embeddedControllerWillChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState;
- (void)embeddedControllerDidChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState;

@end

@protocol GDSheetControllerDelegate <NSObject>
@optional

- (void)sheetController:(GDSheetController *)controller
willChangeEmbeddedController:(UIViewController*)embeddedController
         toDisplayState:(GDSheetState)toState
       fromDisplayState:(GDSheetState)fromState;

- (void)sheetController:(GDSheetController *)controller
didChangeEmbeddedController:(UIViewController*)embeddedController
         toDisplayState:(GDSheetState)toState
       fromDisplayState:(GDSheetState)fromState;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface GDSheetController : UIViewController

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

@property (nonatomic, strong, readonly) NSDictionary                        *options;

@property (nonatomic, assign, readonly) CGFloat                             sheetsStartFromTop;
@property (nonatomic, assign, readonly) CGFloat                             maxDistanceBetweenSheets;
@property (nonatomic, assign, readonly) CGFloat                             sheetMinScaleFactor;
@property (nonatomic, assign, readonly) CGFloat                             sheetFullscreenScaleFactor;

@property (nonatomic, assign, readonly) CGFloat                             sheetCornerRadius;

@property (nonatomic, assign, readonly) GDSheetGestureScope                 sheetGestureScope;
@property (nonatomic, assign, readonly) GDSheetFullscreenMode               sheetFullscreenMode;
@property (nonatomic, assign, readonly) BOOL                                sheetEnableTapGesture;
@property (nonatomic, assign, readonly) NSUInteger                          sheetNumberOfTapRequired;

@property (nonatomic, assign, readonly) CGFloat                             sheetFullScreenDistanceThreshold;
@property (nonatomic, assign, readonly) BOOL                                sheetUserInteractionEnabledInDefaultState;

@property (nonatomic, assign, readonly) CGFloat                             sheetAnimationsDuration;

@property (nonatomic, assign, readonly) BOOL                                sheetShadowEnabled;
@property (nonatomic, assign, readonly) UIColor                             *sheetShadowColor;
@property (nonatomic, assign, readonly) CGSize                              sheetShadowOffset;
@property (nonatomic, assign, readonly) CGFloat                             sheetShadowRadius;
@property (nonatomic, assign, readonly) CGFloat                             sheetShadowOpacity;

@property (nonatomic, weak)             id<GDSheetControllerDelegate>       delegate;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods

+ (instancetype)sheetControllerWithControllers:(NSArray *)arrayOfControllers
                                       options:(NSDictionary *)options;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance Methods

- (id)initWithControllers:(NSArray *)arrayOfControllers
                  options:(NSDictionary *)options;

#pragma mark Embedded controllers state management

- (void)setEmbeddedController:(UIViewController*)embeddedController
                      toState:(GDSheetState)state;

- (void)setEmbeddedController:(UIViewController*)embeddedController
                      toState:(GDSheetState)state
                     animated:(BOOL)animated
                   completion:(GDDefaultCompletionHandler)completion;

#pragma mark Embedded controllers adding / removing

- (BOOL)addEmbeddedController:(UIViewController*)embeddedController;

- (BOOL)removeEmbeddedController:(UIViewController*)embeddedController;

@end
