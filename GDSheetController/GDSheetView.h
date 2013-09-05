//
//  GDSheetView.h
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
#import "GDSheetController.h"

@class GDSheetController;
@class GDSheetView;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Types

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines & Constants

typedef void(^GDSheetCompletionHandler)(GDSheetView *sheet, GDSheetState previousState, BOOL finished);

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Protocols

@protocol GDSheetViewDelegate <NSObject>

@required
//Called when user is panning and a the card has travelled X percent of the distance to the top - Used to redraw other cards during panning fanout
- (void)sheet:(GDSheetView *)sheet didUpdatePanPercentage:(CGFloat)percentage;
- (void)sheet:(GDSheetView *)sheet willBeginPanningGesture:(UIPanGestureRecognizer*)gesture;
- (void)sheet:(GDSheetView *)sheet didEndPanningGesture:(UIPanGestureRecognizer*)gesture;

@optional
//Called on any time a state change has occured - even if a state has changed to itself - (i.e. from GDSheetState_Default to GDSheetState_Default)
- (void)sheet:(GDSheetView *)sheet willChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState;
- (void)sheet:(GDSheetView *)sheet didChangeToDisplayState:(GDSheetState)toState fromDisplayState:(GDSheetState)fromState;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface GDSheetView : UIView

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

@property (nonatomic, strong)                       UIViewController          *embeddedViewController;
@property (nonatomic, strong)                       UIViewController          *previewViewController;
@property (nonatomic, assign, readonly)             UIViewController          *topEmbeddedViewController;
@property (nonatomic, weak)                         id<GDSheetViewDelegate>   delegate;

@property (nonatomic, assign)                       GDSheetState              state;
@property (nonatomic, assign)                       CGFloat                   defaultTopInSuperview;
@property (nonatomic, assign)                       CGFloat                   currentScalingFactor;
@property (nonatomic, getter = areGesturesEnabled)  BOOL                      gesturesEnabled;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance Methods

- (id)initWithEmbeddedController:(UIViewController*)embeddedController
                 sheetController:(GDSheetController*)sheetController;

- (id)initWithEmbeddedController:(UIViewController*)embeddedController
               previewController:(UIViewController*)previewController
                 sheetController:(GDSheetController*)sheetController;

- (void)shrinkSheetToScaledSize:(BOOL)animated;
- (void)expandSheetToFullSize:(BOOL)animated;

- (void)setCurrentScalingFactor:(CGFloat)currentScalingFactor
                       animated:(BOOL)animated;

- (void)setState:(GDSheetState)state
        animated:(BOOL)animated
      completion:(GDSheetCompletionHandler)completion;

- (CGFloat)top;
- (void)setTop:(CGFloat)y;

@end
