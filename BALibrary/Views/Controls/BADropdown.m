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

    for (int section = 0; section < numberOfSections; section++)
    {
        NSInteger numberOfRows = [self tableView:self numberOfRowsInSection:section];

        for (int row = 0; row < numberOfRows; row++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];

            if (indexPath.row == 0 && indexPath.section == 0)
            {
                //skip first row since this is already shown in the collapsed state

                continue;
            }

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

             //first insert sections

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
        [_indexPathForSelectedRow release];
        _indexPathForSelectedRow = [indexPath retain];


        //animation

        [UIView animateWithDuration:0.3 animations:^
        {
            [tableView beginUpdates];

            //first delete sections
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


        //only forward didSelectRowAtIndexPath when selecting an item

        if ([_listener respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [_listener tableView:self didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_collapsed)
    {
        return 1;
    }
    else
    {
        return [_listener tableView:self numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selects the _indexPathForSelectedRow when not collapsed and removes selection when collapsed

    if (_collapsed)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return [_listener tableView:self cellForRowAtIndexPath:_indexPathForSelectedRow];
    }
    else
    {
        if ([indexPath isEqual:_indexPathForSelectedRow])
        {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }

        return [_listener tableView:self cellForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (_collapsed || ![_listener respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return 1;
    }

    return [_listener numberOfSectionsInTableView:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_collapsed)
    {
        return nil;
    }
    else
    {
        if (![_listener respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
        {
            return nil;
        }

        return [_listener tableView:self titleForHeaderInSection:section];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (_collapsed)
    {
        return nil;
    }
    else
    {
        if (![_listener respondsToSelector:@selector(tableView:titleForFooterInSection:)])
        {
            return nil;
        }

        return [_listener tableView:self titleForFooterInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_listener respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return 44;//default size
    }

    return [_listener tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)dealloc
{
    self.listener = nil;
    [_indexPathsForHiddenRows release];
    [_indexPathForSelectedRow release];

    [super dealloc];
}


@end
