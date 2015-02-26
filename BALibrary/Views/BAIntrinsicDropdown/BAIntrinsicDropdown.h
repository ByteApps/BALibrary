//
//  BAIntrinsicDropdown.h
//  BALibrary
//
//  Created by Salvador Guerrero on 2/25/15.
//  Copyright (c) 2015 ByteApps. All rights reserved.
//

#import "BAIntrinsicTableView.h"

@interface BAIntrinsicDropdown : BAIntrinsicTableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) NSMutableArray *selectedIndexPaths;

@end
