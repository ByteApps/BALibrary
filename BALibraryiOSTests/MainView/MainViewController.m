//
//  MainViewController.m
//  BALibraryiOSTests
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

#define SEARCHBAR_TAG (1)

@implementation MainViewController
{
    BASearchBar *_baSearcBar;
    IBOutlet BADropdown  *_baDropdown;
    IBOutlet BATextField *_baTextField;

    NSArray     *_baDropdownItems;
}

#if 0 //TODO: Fix BASearchBar and BADropdown for AutoLayout
- (void)loadView
{
    MainView *view = [[MainView new] autorelease];

    //set references

    _baSearcBar = view.baSearcBar;
    _baDropdown = view.baDropdown;

    self.view = view;
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];

    _baDropdownItems = [@[@[@"First", @"Second", @"Third"],@[@"Forth", @"Fifth", @"Sixth"]] retain];

    _baDropdown.listener = self;

    _baTextField.mask = @"(xxx) xxx-xxxx";
    _baTextField.placeholder = _baTextField.mask;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == SEARCHBAR_TAG)
    {
        return 100;
    }
    else //if (tableView == _baDropdown)
    {
        return [_baDropdownItems[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }

    cell.textLabel.text = @"";

    if (tableView == _baDropdown)
    {
        cell.textLabel.text = _baDropdownItems[indexPath.section][indexPath.row];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %ld", section];
}

- (void)dealloc
{
    [_baDropdown release];
    [_baDropdownItems release];

    [_baTextField release];
    [super dealloc];
}
@end
