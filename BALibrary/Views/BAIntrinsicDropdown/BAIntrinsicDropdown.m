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

#if 0 // Not needed for now
{

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

}
#endif

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
             // animation has finished

             [self invalidateIntrinsicContentSize];
         }];

        _collapsed = YES;

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (void)headerTapped:(UIControl *)control
{
    _collapsed = !_collapsed;

    [CATransaction begin];
    [CATransaction setCompletionBlock:^
     {
         // animation has finished

         [self invalidateIntrinsicContentSize];

         //select the previous selected cells

         if (!_collapsed && _selectedIndexPaths.count)
         {
             for (int i = 0; i < _selectedIndexPaths.count; i++)
             {
                 [self selectRowAtIndexPath:_selectedIndexPaths[i] animated:NO scrollPosition:UITableViewScrollPositionNone];
             }
         }
     }];

    [self beginUpdates];

    if (!_collapsed)//checking for old value
    {
        //add rows

        NSInteger numberOfRows = [_externalDataSource tableView:self numberOfRowsInSection:0];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:numberOfRows];

        for (int i = 0; i < numberOfRows; i++)
        {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [_selectedIndexPaths removeAllObjects];
        [_selectedIndexPaths addObjectsFromArray:self.indexPathsForSelectedRows];

        [self deleteRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [self endUpdates];

    [CATransaction commit];
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

#if 0 // Not Needed for now
{
    - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
    - (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
    - (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
    - (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
    - (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
    - (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

    // Variable height support

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
    - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

    // Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
    // If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
    - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0);
    - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
    - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);

    // Section header & footer information. Views are preferred over title should you decide to provide both

    - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

    // Accessories (disclosures).

    - (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0);
    - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

    // Selection

    // -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
    // Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
    - (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
    - (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
    - (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);

    // Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
    - (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
    - (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

    // Editing

    // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
    - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
    - (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
    - (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil

    // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
    - (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

    // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
    - (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
    - (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

    // Moving/reordering

    // Allows customization of the target row for a particular row as it is being moved/reordered
    - (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

    // Indentation

    - (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

    // Copy/Paste.  All three methods must be implemented by the delegate.

    - (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0);
    - (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0);
    - (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0);
}
#endif

- (void)dealloc
{
    self.title = nil;
    [_selectedIndexPaths release];
    [_headerControl release];

    [super dealloc];
}


@end
