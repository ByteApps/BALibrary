//
//  ViewController.m
//  BALibraryiOSTests
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "ViewController.h"

#define SEARCHBAR_TAG (1)

@implementation ViewController
{

    IBOutlet BADropdown *_baDropdown;

    NSArray             *_baDropdownItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _baDropdownItems = [@[@[@"First", @"Second", @"Third"],@[@"Forth", @"Fifth", @"Sixth"]] retain];

    _baDropdown.listener = self;
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

    [super dealloc];
}
@end
