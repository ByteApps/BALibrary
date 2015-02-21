//
//  BASearchBar.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

/* ¡IMPORTANT!
 *
 * BASearchBar was developer using iOS7, not tested on any other version.
 *
 * Disable AutoLayout when using this control.
 */

/* What is it?
 *
 * A control that mimics the behaviour of UISearchDisplayController but with limited functionality.
 */

/* How can I make it work?
 *
 * you drag a UITextField to your view using the nib editor
 * set its class to BASearchBar and the delegate to its viewController (it has to be UIViewController)
 * assign a tag you can remember, you will use this tag to identify the tableViewController for the delegate events.
 * you implement the necessary methods of BASearchBarDelegate.
 */

/* What happens behind the scenes?
 *
 * The BASearchBar(UITextField) gets replaced by the internal BARealSearchBar interface and copies
 * all the relevant TextField attributed like frame, font, etc.
 */

/*
 * Not responding to a few delegte methods?
 * 
 * Take a look at the source code, just add the missing methods.
 */


#import <UIKit/UIKit.h>

#pragma mark - BASearchBar interface

@interface BASearchBar : UITextField

@end

#pragma mark - BASearchBar protocol

@protocol BASearchBarDelegate <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@end