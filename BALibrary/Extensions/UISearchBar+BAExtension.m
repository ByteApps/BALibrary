//
//  UISearchBar+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "UISearchBar+BAExtension.h"

@implementation UISearchBar (BAExtension)

- (UITextField *)textField
{
    return (UITextField *)[self viewWithClass:UITextField.class];
}

@end
