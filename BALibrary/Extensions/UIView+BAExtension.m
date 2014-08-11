//
//  UIView+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "UIView+BAExtension.h"

@implementation UIView (BAExtension)

- (UIView *)viewWithClass:(Class)aClass
{
    if ([self isKindOfClass:aClass])
    {
        return self;
    }

    for(UIView *subView in self.subviews)
    {
        UIView *result = [subView viewWithClass:aClass];

        if (result)
        {
            return result;
        }
    }

    return nil;
}

@end
