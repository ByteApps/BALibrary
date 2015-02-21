//
//  MainView.m
//  BALibrary
//
//  Created by Salvador Guerrero on 2/20/15.
//  Copyright (c) 2015 ByteApps. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = UIColor.redColor;

        _baSearcBar = [[BASearchBar new] autorelease];
        _baSearcBar.translatesAutoresizingMaskIntoConstraints = NO;
        _baSearcBar.tag = 1;
        [self addSubview:_baSearcBar];

        _baDropdown = [[BADropdown new] autorelease];
        _baDropdown.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_baDropdown];

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_baSearcBar, _baDropdown);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baSearcBar]-|" options:0 metrics:nil views:bindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baDropdown]-|" options:0 metrics:nil views:bindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_baSearcBar]-[_baDropdown(>=0)]-|" options:0 metrics:nil views:bindings]];
    }

    return self;
}

@end
