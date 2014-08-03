//
//  UIButton+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 7/10/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "UIButton+BAExtension.h"

@implementation UIButton (BAExtension)

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (NSString*)title
{
    return self.titleLabel.text;
}

@end
