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
    NSArray         *_allCells;
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
    self.delegate = self;
    self.dataSource = self;
}

- (void)setListener:(id<UITableViewDelegate,UITableViewDataSource>)listener
{
    [listener retain];
    [_listener release];
    _listener = listener;

    [_allCells release], _allCells = nil;

    if (!listener)
    {
        return;
    }

    //save all the cells in memory

    NSInteger numberOfRows = [_listener tableView:self numberOfRowsInSection:0];
    NSMutableArray *newCells = [NSMutableArray arrayWithCapacity:numberOfRows];

    for (int i = 0; i < numberOfRows; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [_listener tableView:self cellForRowAtIndexPath:indexPath];
        [newCells addObject:cell];
    }

    _allCells = [[NSArray alloc] initWithArray:newCells];
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

    [self shrinkFrameToContentSize];
}

- (void)shrinkFrameToContentSize
{
    CGRect selfFrame = self.frame;
    selfFrame.size = self.contentSize;
    self.frame = selfFrame;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    //always create a new cell because we are storing them in an array.

    return nil;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    //always create a new cell because we are storing them in an array.
    
    return nil;
}

- (NSArray *)indexPathsForUnselectedRows
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:_allCells.count-1];

    for (int i = 0; i < _allCells.count; i++)
    {
        if (_indexPathForSelectedRow.row == i)
        {
            continue;
        }

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [result addObject:indexPath];
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
        _collapsed = YES;

        //animation

        [UIView animateWithDuration:0.3 animations:^
        {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[self indexPathsForUnselectedRows] withRowAnimation:UITableViewRowAnimationFade];
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
        return _allCells.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selects the _indexPathForSelectedRow when not collapsed and removes selection when collapsed

    if (_collapsed)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *cell = _allCells[_indexPathForSelectedRow.row];
        return cell;
    }
    else
    {
        UITableViewCell *cell = _allCells[indexPath.row];

        if (indexPath.row == _indexPathForSelectedRow.row)
        {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* Currently only handles 1 section,
     * will handle more in the future where it shows 1 section without header when is collapsed.
     */

    return 1;
}

- (void)dealloc
{
    self.listener = nil;
    [_indexPathsForHiddenRows release];
    [_indexPathForSelectedRow release];
    [_allCells release];

    [super dealloc];
}


@end
