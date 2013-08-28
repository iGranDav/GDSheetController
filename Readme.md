GDSheetViewController
=====================

``GDSheetViewController`` is a controller to organize multiple controllers or navigation controllers in a  stack of sheets inspired by __*Evernote Food 2.0*__ app.

<img src="https://raw.github.com/iGranDav/GDSheetViewController/master/GDSheetControllerDemo/GDSheetControllerDemo/Images/ios6_screen.png" width="35%"/>
<img src="https://raw.github.com/iGranDav/GDSheetViewController/master/GDSheetControllerDemo/GDSheetControllerDemo/Images/ios7_screen.png" width="35%"/>

**Note**: If ``GDSheetViewController`` provide a better user experience in portrait it will be usable in landscape too.

Support
-------
This component was designed and tested for **iOS 6** and **iOS 7** but may be compatible with iOS 5. No tests has been made on this platform through.

Screens
-------
You can customize spaces between sheets but ``GDSheetViewController`` automatically adapts its layout for displaying all your sheets on screen. That is why you define a maximum space between your sheets.

Known Issues
------------
- **FIXED** ~~iOS7 support~~
- Handling orientation changes correctly
 - Still having an issue when moving from landscape right to landscape left.
 - Fullscreen controllers won't go landscape

Thanks to
---------
This component is *highly* inspired from [``KLNoteViewController``](https://github.com/KieranLafferty/KLNoteViewController) by [Kieran Lafferty](https://github.com/kieranlafferty). Thanks to him.

Got some ideas from [``PKRevealController``](https://github.com/pkluz/PKRevealController) too, thanks to [pkluz](https://github.com/pkluz).

Licence
-------

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

