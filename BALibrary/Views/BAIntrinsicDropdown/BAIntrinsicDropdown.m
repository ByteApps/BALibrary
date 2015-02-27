//
//  BAIntrinsicDropdown.m
//  BALibrary
//
//  Created by Salvador Guerrero on 2/25/15.
//  Copyright (c) 2015 ByteApps. All rights reserved.
//

#import "BAIntrinsicDropdown.h"

@implementation BAIntrinsicDropdown
{
    id<UITableViewDataSource>   _externalDataSource;
    id<UITableViewDelegate>     _externalDelegate;
    BOOL                        _collapsed;
    UIControl                   *_headerControl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _collapsed = YES;
        _selectedIndexPaths = [[NSMutableArray array] retain];
        super.dataSource = self;
        super.delegate = self;
        self.scrollEnabled = NO;
    }

    return self;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    _externalDataSource = dataSource;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    _externalDelegate = delegate;
}

- (CGSize)contentSize
{
    if (_collapsed)
    {
        return CGSizeZero;
    }

    CGFloat height = 44;

    if ([_externalDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        height = [_externalDelegate tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }

    return CGSizeMake(super.contentSize.width, height * [_externalDataSource tableView:self numberOfRowsInSection:0]);
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collapsed? 0 : [_externalDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_externalDataSource tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //this is just a dropdown, it has just one section.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableString *title = [NSMutableString stringWithString:_title?_title:@""];

    if (!self.allowsMultipleSelection && _selectedIndexPaths.count)
    {
        UITableViewCell *selectedCell = [_externalDataSource tableView:tableView cellForRowAtIndexPath:_selectedIndexPaths[0]];

        [title appendFormat:@" %@", selectedCell.textLabel.text];
    }

    return title;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_externalDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [_externalDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

    if (![_selectedIndexPaths containsObject:indexPath])
    {
        [_selectedIndexPaths addObject:indexPath];
    }

    if (!self.allowsMultipleSelection)
    {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^
         {
             //CATransaction is used to add a completion block when deleteRowsAtIndexPaths animation finishes.

             [UIView animateWithDuration:0.3 animations:^
             {
                 //update the header.

                 [self tableView:self viewForHeaderInSection:0];
             }];
         }];

        [tableView beginUpdates];

        _collapsed = YES;

        [self invalidateIntrinsicContentSize];

        [UIView animateWithDuration:0.3 animations:^
         {
             [self layoutIfNeeded];
         }];

        [tableView deleteRowsAtIndexPaths:self.indexPathsForAllRows withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [CATransaction commit];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_externalDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [_externalDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }

    [_selectedIndexPaths removeObject:indexPath];
}

- (NSArray *)indexPathsForAllRows
{
    NSInteger rowCount = [_externalDataSource tableView:self numberOfRowsInSection:0];
    NSMutableArray *allIndexPaths = [NSMutableArray arrayWithCapacity:rowCount];

    for (int i = 0; i < rowCount; i++)
    {
        [allIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    return allIndexPaths;
}

- (void)headerTapped:(UIControl *)control
{
    if (_collapsed)
    {
        //doing the frame animation first so the table draws all the visible cells

        _collapsed = !_collapsed;

        //invalidate the table's intrinsic size

        [self invalidateIntrinsicContentSize];

        [UIView animateWithDuration:0.3 animations:^
        {
            //animate the resize

            [self layoutIfNeeded];
        }];

        //add rows

        [self beginUpdates];
        {
            NSInteger numberOfRows = [_externalDataSource tableView:self numberOfRowsInSection:0];
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:numberOfRows];

            for (int i = 0; i < numberOfRows; i++)
            {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }

            [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self endUpdates];

        //select the previously selected cells

        if (_selectedIndexPaths.count)
        {
            for (int i = 0; i < _selectedIndexPaths.count; i++)
            {
                [self selectRowAtIndexPath:_selectedIndexPaths[i] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    else
    {
        //when collapsing we need to do everything inside the update block
        //so we can see the row animation plus the frame animation.

        [self beginUpdates];
        {
            _collapsed = !_collapsed;

            [self invalidateIntrinsicContentSize];

            [UIView animateWithDuration:0.3 animations:^
             {
                 [self layoutIfNeeded];
             }];

            [self deleteRowsAtIndexPaths:self.indexPathsForAllRows withRowAnimation:UITableViewRowAnimationTop];
        }
        [self endUpdates];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;

    if (!_headerControl)
    {
        _headerControl = [UIControl new];
        _headerControl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_headerControl addTarget:tableView action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
        _headerControl.backgroundColor = UIColor.whiteColor;
    }
    else
    {
        //remove all subviews, a new one is going to be added below.

        [_headerControl.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    if ([_externalDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        view = [_externalDelegate tableView:tableView viewForHeaderInSection:section];
    }

    if (!view)
    {
        view = [[UIView new] autorelease];
        view.backgroundColor = UIColor.clearColor;

        UILabel *label = [[UILabel new] autorelease];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.backgroundColor = UIColor.clearColor;
        label.textColor = UIColor.blackColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self tableView:self titleForHeaderInSection:0];
        label.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label];

        NSDictionary *bindings = NSDictionaryOfVariableBindings(label);

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[label]|" options:0 metrics:nil views:bindings]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:bindings]];
    }

    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.userInteractionEnabled = NO; //send all the touches to _headerControl.

    [_headerControl addSubview:view];

    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);

    [_headerControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:bindings]];
    [_headerControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:bindings]];

    return _headerControl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_externalDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        return [_externalDelegate tableView:tableView heightForHeaderInSection:section];
    }

    return 45;
}

- (void)dealloc
{
    self.title = nil;
    [_selectedIndexPaths release];
    [_headerControl release];

    [super dealloc];
}


@end
