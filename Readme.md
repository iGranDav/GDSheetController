GDSheetController
=====================

``GDSheetController`` is a controller to organize multiple controllers or navigation controllers in a stack of sheets inspired by __*Evernote Food 2.0*__ app.

<img src="https://raw.github.com/iGranDav/GDSheetController/master/GDSheetControllerDemo/GDSheetControllerDemo/Images/ios6_screen.png" width="35%"/>
<img src="https://raw.github.com/iGranDav/GDSheetController/master/GDSheetControllerDemo/GDSheetControllerDemo/Images/ios7_screen.png" width="35%"/>

**Note**: If ``GDSheetController`` provide a better user experience in portrait it will be usable in landscape too.

Installation
------------
Installation may be as simple as using it ;-)

###Cocoapods
If you are using **CocoaPods**

1. Simply add ``pod 'GDSheetController', '~> 0.1.0'`` to your podfile
2. And then run 
 - ``pod update`` if you already have a project with pods
 - ``pod install`` to integrate your pods to your project

To know more about CocoaPods and usage, visit their [website](http://cocoapods.org).

###Manual install
1. Download the **ZIP** from *Github* and copy the **GDSheetController** directory to your project
2. Link the ``QuartzCore.framework`` library in your project's Build Phases
3. ``#import "GDSheetController.h"`` and enjoy :-)

###Support and tested environments
This component was designed and tested for **iOS 6** and **iOS 7** but may be compatible with iOS 5. No tests has been made on this platform through.

Usage
-----
You may need to use ``GDSheetController`` as a root view controller. No need to subclass it.

###Example in your appDelegate

```objc
NSArray *arrayOfControllers = @[vc1, vc2, vc3];
[GDSheetController sheetControllerWithControllers:arrayOfControllers
                                          options:nil];
```

###Options and personalization
A lot of options are available in ``GHSheetController.h`` and can be passed in options dictionary at init.

Example:
```objc
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

NSArray *arrayOfControllers = @[vc1, vc2, vc3];
NSDictionary *options       = @{GDSheetControllerSheetGestureScopeKey:@(GDSheetGestureScope_All)}

[GDSheetController sheetControllerWithControllers:arrayOfControllers
										  options:options];
```

Screens
-------

###Distance between sheets
You can customize spaces between sheets but ``GDSheetController`` automatically adapts its layout for displaying **all** your sheets on screen. That is why you define a maximum space between your sheets using ``GDSheetControllerMaxDistanceBetweenSheetsKey``.

```objc
/**
 * Determines the max distance between sheets to show embedded controller
 * content when sheets are closed
 *
 * @default 70.f
 * @value NSNumber containing CGFloat
 */
extern NSString * const GDSheetControllerMaxDistanceBetweenSheetsKey;
```
###Managing fullscreen when using as a child ViewController
When GDSheetController is embedded in a ``UINavigationController`` or if your are using it as a custom child ``UIViewController`` you can experience some issues with Fullscreen sheets. That is why ``GDSheetController`` propose a fullscreen mode via the ``GDSheetControllerSheetFullscreenModeKey`` option.

You can choose:

- **GDSheetFullscreenMode_Controller**
 - Sheet go fullscreen inside the sheet controller only! (*by default*)
- **GDSheetFullscreenMode_Screen**
 - Sheet go fullscreen on the whole screen (*following current keyWindow*) and go outside the sheet controller

Then your controllers will pass above the existing ``UINavigationBar`` of the ``UINavigationController`` embedding your ``GDSheetController``.

Known Issues
------------
- **FIXED** ~~iOS7 support~~
- Handling orientation changes correctly
 - Still having an issue when moving from landscape right to landscape left.
 - Fullscreen controllers won't go landscape
- When using ``GDSheetFullscreenMode_Screen`` back to default animation does **NOT** run smoothly.
- Make an iPad demo

If you find any other bugs, please open a new issue.

You want a new feature ? Please open a new issue too or fork me and propose your pull request.

Thanks to
---------
This component is *highly* inspired from [``KLNoteViewController``](https://github.com/KieranLafferty/KLNoteViewController) by [Kieran Lafferty](https://github.com/kieranlafferty). Thanks to him.

Got some ideas from [``PKRevealController``](https://github.com/pkluz/PKRevealController) too, thanks to [Philip Kluz](https://github.com/pkluz).

License
-------
I used MIT license, basically you can do whatever you want, I appreciate attribution or a simple link to this page if you used it.

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

