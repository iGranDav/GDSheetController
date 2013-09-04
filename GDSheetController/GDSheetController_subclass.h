//
//  GDSheetController_subclass.h
//  GDSheetViewControllerDemo
//
//  Created by David Bonnet on 04/09/13.
//  Copyright (c) 2013 David Bonnet. All rights reserved.
//

#import "GDSheetController.h"

@interface GDSheetController ()

/**
 *	Use this method if you subclass GDSheetController to add embedded controllers
 *  configured with default options
 *
 *	@param	arrayOfControllers	array of UIViewController object that will be integrated as sheets
 */
- (void)setEmbeddedControllers:(NSArray*)arrayOfControllers;

/**
 *	Use this method if you subclass GDSheetController to add embedded controllers
 *  configured with your options
 *
 *	@param	arrayOfControllers	array of UIViewController object that will be integrated as sheets
 *	@param	options	 dictionary of options described in GDSheetController header file
 */
- (void)setEmbeddedControllers:(NSArray*)arrayOfControllers withOptions:(NSDictionary*)options;

@end
