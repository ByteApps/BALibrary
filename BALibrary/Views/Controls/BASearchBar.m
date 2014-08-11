//
//  BASearchBar.m
//  BALibrary
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "BASearchBar.h"

#pragma mark - BARealSearchBar interface

@interface BARealSearchBar : UISearchBar <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>   viewController;

+ (instancetype)realSearchBarFromTextField:(UITextField *)textField;

@end

#pragma mark - BASearchDisplayController interface

@interface BASearchDisplayController : UIViewController

@property (nonatomic, retain) BARealSearchBar   *searchBar;

+ (instancetype)searchDisplayControllerWithSearchBar:(BARealSearchBar *)searchBar;

@end


#pragma mark - Implementations

@implementation BASearchBar

- (void)didMoveToWindow
{

    if (!self.superview)
    {
        //ignore if superview is nil

        return;
    }

    //do the replacement here, delegate gets set before this method and also so we can call removeFromSuperview once the TextField is added

    [self.superview insertSubview:[BARealSearchBar realSearchBarFromTextField:self] atIndex:[self.superview.subviews indexOfObject:self]];

    [self removeFromSuperview];
}

@end

@implementation BASearchDisplayController
{
    CGRect      _searchBarOriginFrame;
    CGRect      _searchBarFrame;
    UIView      *_headerView;
    UITableView *_tableView;
}

- (void)setSearchBar:(BARealSearchBar *)searchBar
{
    [searchBar retain];
    [_searchBar release];
    _searchBar = searchBar;

    _searchBarOriginFrame = searchBar.frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    //set semitransparent background

    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];

    //add a header view

    _headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)] autorelease];
    _headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    [self.view addSubview:_headerView];

    //add the tableView

    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - _headerView.bounds.size.height) style:UITableViewStylePlain] autorelease];
    _tableView.tag = _searchBar.tag;
    _tableView.delegate = _searchBar;
    _tableView.dataSource = _searchBar;
    _tableView.alpha = 0.0;
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [_headerView addSubview:_searchBar];

    _searchBarFrame = _searchBar.frame;

    _searchBarFrame.origin.y = _headerView.bounds.size.height - _searchBar.bounds.size.height;
    _searchBarFrame.origin.x = 0;
    _searchBarFrame.size.width = self.view.bounds.size.width;

    [UIView animateWithDuration:0.3 animations:^
    {
        _searchBar.frame = _searchBarFrame;
    }
    completion:^(BOOL finished)
    {
        [_searchBar setShowsCancelButton:YES animated:YES];

        [UIView animateWithDuration:0.1 animations:^
        {
            _tableView.alpha = 1.0;
        }
        completion:^(BOOL finished)
        {

        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    UIViewController *delegate = (id)_searchBar.viewController;

    [delegate.view addSubview:_searchBar];

    //now restore _searchBar original position

    [_searchBar setShowsCancelButton:NO animated:YES];

    [UIView animateWithDuration:0.3 animations:^
    {
        _searchBar.frame = _searchBarOriginFrame;
    }
    completion:^(BOOL finished)
    {

    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];


}

+ (instancetype)searchDisplayControllerWithSearchBar:(BARealSearchBar *)searchBar
{
    BASearchDisplayController *displayController = [[BASearchDisplayController new] autorelease];
    displayController.searchBar = searchBar;

    return displayController;
}

- (void)dealloc
{
    [_searchBar release];

    [super dealloc];
}

@end

@implementation BARealSearchBar
{
    BASearchDisplayController   *_displayController;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self internalInit];
    }

    return self;
}

- (void)internalInit
{
    self.searchBarStyle = UISearchBarStyleMinimal;
    self.barStyle = UIBarStyleDefault;
    self.delegate = self; //will forward events to _viewControllersSearchBarDelegate
}

+ (instancetype) realSearchBarFromTextField:(UITextField *)textField
{
    BARealSearchBar *searchBar = [[[BARealSearchBar alloc] initWithFrame:textField.frame] autorelease];
    UITextField *searchBarTextField = searchBar.textField;

    //set relevant properties.
    searchBar.tag = textField.tag;
    searchBar.viewController = (id)textField.delegate;
    searchBar.autoresizingMask = textField.autoresizingMask;
    searchBar.placeholder = textField.placeholder;

    //properties set directly into the TextField.

    searchBarTextField.font = textField.font;

    //confugure the search display controller

    return searchBar;
}

- (void)presentDisplayController
{
    if (_displayController)
    {
        return;
    }

    _displayController = [[BASearchDisplayController searchDisplayControllerWithSearchBar:self] retain];

    [((UIViewController *)_viewController) presentViewController:_displayController animated:NO completion:^
     {

     }];
}

- (void)dismissDisplayController
{
    //need to dismiss the controller without animations here,
    //all animations are done inside the controller implementation.
    //if animation is set to true in dismissViewControllerAnimated
    //it will break animations inside the implementation.

    [_displayController dismissViewControllerAnimated:NO completion:^
     {
         [_displayController release];
         _displayController = nil;
     }];
}

#pragma mark - UISearchBarDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarShouldBeginEditing:)])
    {
        [self presentDisplayController];
        return YES;
    }

    BOOL result = [_viewController searchBarShouldBeginEditing:searchBar];

    if (result)
    {
        [self presentDisplayController];
    }

    return result;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        return;
    }

    [_viewController searchBarTextDidBeginEditing:searchBar];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarShouldEndEditing:)])
    {
        return YES;
    }

    return [_viewController searchBarShouldEndEditing:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        return;
    }

    [_viewController searchBarTextDidEndEditing:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![_viewController respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        return;
    }

    [_viewController searchBar:searchBar textDidChange:searchText];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![_viewController respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return YES;
    }

    return [_viewController searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        return;
    }

    [_viewController searchBarSearchButtonClicked:searchBar];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarBookmarkButtonClicked:)])
    {
        return;
    }

    [_viewController searchBarBookmarkButtonClicked:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self dismissDisplayController];

    if (![_viewController respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        return;
    }

    [_viewController searchBarCancelButtonClicked:searchBar];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    if (![_viewController respondsToSelector:@selector(searchBarResultsListButtonClicked:)])
    {
        return;
    }

    [_viewController searchBarResultsListButtonClicked:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if (![_viewController respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)])
    {
        return;
    }

    [_viewController searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;

    if ([_viewController respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
    {
        rowCount = [_viewController tableView:tableView numberOfRowsInSection:section];
    }

    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if ([_viewController respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)])
    {
        cell = [_viewController tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_viewController respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [_viewController tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

    [self dismissDisplayController];
}

- (void)dealloc
{
    [_displayController release];

    [super dealloc];
}

@end