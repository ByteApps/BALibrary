//
//  BADropdown.m
//  BALibrary
//
//  Created by Salvador Guerrero on 8/16/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "BADropdown.h"

@implementation BADropdown
{
    BOOL            _collapsed;
    NSMutableArray  *_indexPathsForHiddenRows;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self internalInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self internalInit];
    }

    return self;
}

- (void)internalInit
{
    _collapsed = YES;
    _indexPathForSelectedRow = [[NSIndexPath indexPathForRow:0 inSection:0] retain];
    self.scrollEnabled = NO;
    self.delegate = self;
    self.dataSource = self;
}

- (void)setListener:(id<UITableViewDelegate,UITableViewDataSource>)listener
{
    [listener retain];
    [_listener release];
    _listener = listener;

    if (!listener)
    {
        return;
    }
}

- (void)setIndexPathForSelectedRow:(NSIndexPath *)indexPathForSelectedRow
{
    [indexPathForSelectedRow retain];
    [_indexPathForSelectedRow release];
    _indexPathForSelectedRow = indexPathForSelectedRow;

    [self reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //just in case if the parent viewController has self.automaticallyAdjustsScrollViewInsets = YES;

    if (self.contentOffset.y != 0)
    {
        self.contentOffset = CGPointZero;
    }

    [self shrinkFrameToContentSize];
}

- (void)shrinkFrameToContentSize
{
    if (self.frame.size.height != self.contentSize.height)
    {
        CGRect selfFrame = self.frame;
        selfFrame.size = self.contentSize;
        self.frame = selfFrame;
    }
}

- (NSArray *)indexPathsForUnselectedRows
{
    NSMutableArray *result = [NSMutableArray array];

    NSInteger numberOfSections = [self numberOfSectionsInTableView:self];

    for (int section = 1; section < numberOfSections; section++)
    {
        NSInteger numberOfRows = [self tableView:self numberOfRowsInSection:section];

        for (int row = 0; row < numberOfRows; row++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];

//            if (indexPath.row == 0 && indexPath.section == 0)
//            {
//                //skip first row since this is already shown in the collapsed state
//
//                continue;
//            }

            [result addObject:indexPath];
        }
    }

    return [NSArray arrayWithArray:result];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_collapsed)
    {
        _collapsed = NO;

        [UIView animateWithDuration:0.3 animations:^
         {
             //need to update before calling reloadData

             [tableView beginUpdates];

             //first insert sections, other than section 0

             NSInteger numberOfSections = [self numberOfSectionsInTableView:self];
             if (numberOfSections > 1)
             {
                 NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, numberOfSections-1)];
                 [tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
             }

             //now insert the rows

             [tableView insertRowsAtIndexPaths:[self indexPathsForUnselectedRows] withRowAnimation:UITableViewRowAnimationFade];
             [tableView endUpdates];

             //call reloadData so it calls layoutSubviews and it set the frame to contentSize for the above animatino to work

             [self reloadData];
         }];
    }
    else
    {
        //animation

        [UIView animateWithDuration:0.3 animations:^
        {
            [tableView beginUpdates];

            //first delecte sections, other than section 0

            NSInteger numberOfSections = [self numberOfSectionsInTableView:self];
            if (numberOfSections > 1)
            {
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, numberOfSections-1)];
                [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }

            //delete all rows except the first one because this one is going to be used in the colapsed view to show current value
            
            NSMutableArray *indexPaths = [NSMutableArray arrayWithArray:self.indexPathsForVisibleRows];
            [indexPaths removeObjectAtIndex:0];

            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

            //set _collapsed after calling indexPathsForUnselectedRows and before calling endUpdates
            //indexPathsForUnselectedRows calls the listener methods
            //endUpdates calls the number of rows to verify that the data has been updated.

            _collapsed = YES;
            
            [tableView endUpdates];
        }
        completion:^(BOOL finished)
        {
            //call reloadData after the delete animation has been completed because calling reloadData will shrink its frame to contentSize

            [self reloadData];
        }];

        if (indexPath.section == 0)
        {
            //don't forward the didSelectRowAtIndexPath action when tapping section 0, since th elistener doens't know about it

            return;
        }

        //listener doesn't know about the first section, so substract one section.

        NSIndexPath *forwardIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];

        //save the last selected item after we have verified its not section 0

        [_indexPathForSelectedRow release];
        _indexPathForSelectedRow = [forwardIndexPath retain];

        //only forward didSelectRowAtIndexPath when selecting an item

        if ([_listener respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [_listener tableView:self didSelectRowAtIndexPath:forwardIndexPath];
        }
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        //always displays the selected item

        return 1;
    }

    if (_collapsed)
    {
        //when collapsed we don't show any rows

        return 0;
    }

    //listener doesn't know about the first section, so substract one section.

    section--;

    return [_listener tableView:self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //displays selected item

        return [_listener tableView:self cellForRowAtIndexPath:_indexPathForSelectedRow];
    }

    //listener doesn't know about the first section, so substract one section.

    NSIndexPath *forwardIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];

    //cellForRowAtIndexPath is not going to get called when collapsed by any other section other than 0

    if ([forwardIndexPath isEqual:_indexPathForSelectedRow])
    {
        [tableView selectRowAtIndexPath:forwardIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

    return [_listener tableView:self cellForRowAtIndexPath:forwardIndexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numberOfSections = 1;// section 0 is always shown.

    if (_collapsed)
    {
        return numberOfSections;
    }

    if ([_listener respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        numberOfSections += [_listener numberOfSectionsInTableView:tableView];
    }
    else
    {
        //when numberOfSectionsInTableView is not implemented by the viewController, it means they only want one section.
        
        numberOfSections++;
    }

    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        //don't show title for section 0

        return nil;
    }

    //listener doesn't know about the first section, so substract one section.

    section--;

//    if (_collapsed)
//    {
//        return nil;
//    }
//    else
//    {
        if (![_listener respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
        {
            return nil;
        }

        return [_listener tableView:self titleForHeaderInSection:section];
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        //don't show footer for section 0

        return nil;
    }

    //listener doesn't know about the first section, so substract one section.

    section--;

//    if (_collapsed)
//    {
//        return nil;
//    }
//    else
//    {
        if (![_listener respondsToSelector:@selector(tableView:titleForFooterInSection:)])
        {
            return nil;
        }

        return [_listener tableView:self titleForFooterInSection:section];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_listener respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return 44;//default size
    }

    //listener doesn't know about the first section, so substract one section.

    NSIndexPath *forwardIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];

    return [_listener tableView:tableView heightForRowAtIndexPath:forwardIndexPath];
}

- (void)dealloc
{
    self.listener = nil;
    [_indexPathsForHiddenRows release];
    [_indexPathForSelectedRow release];

    [super dealloc];
}


@end
