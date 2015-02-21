//
//  BADropdown.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/16/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <UIKit/UIKit.h>

/* BADropdown
 *
 * Widget that simulates a dropdown list, collapsing it self when selecting a cell,
 * the initial state is collapsed.
 *
 * listener should implement UITableViewDelegate and UITableViewDataSource
 * don't set self.delegate to somethign else, this object sets its delegate to itself.
 * if you don't set something to indexPathForSelectedRow it will default to [0,0].
 *
 * it internally uses section 0 for displaying the current item.
 *
 */

@interface BADropdown : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSIndexPath   *indexPathForSelectedRow;

@property (nonatomic, retain) id<UITableViewDelegate, UITableViewDataSource> listener;

@end
