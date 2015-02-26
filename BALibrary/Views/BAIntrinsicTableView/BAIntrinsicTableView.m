//
//  BAIntrinsicTableView.m
//  BALibrary
//
//  Created by Salvador Guerrero on 2/25/15.
//  Copyright (c) 2015 ByteApps. All rights reserved.
//

#import "BAIntrinsicTableView.h"

@implementation BAIntrinsicTableView

//- (void)reloadData
//{
//    [super reloadData];
//
//    [self invalidateIntrinsicContentSize];
//}

- (CGSize)intrinsicContentSize
{
    /* To reflect the new size in AutoLayout when the content of the table changes do the following calls:
     *
     * 1. [tableView reloadData];
     * 2. [tableView invalidateIntrinsicContentSize];
     */

    CGFloat height = self.contentSize.height;

    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        height += [self.delegate tableView:self heightForHeaderInSection:0];
    }

    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
    {
        height += [self.delegate tableView:self heightForFooterInSection:self.numberOfSections - 1];
    }

    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

@end
