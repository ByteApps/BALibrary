//
//  UIView+BAExtension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/9/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BAExtension)

- (UIView *)viewWithClass:(Class)aClass; //recursive search. includes self
- (NSArray *)viewsWithClass:(Class)aClass; //recursive search. includes self

- (void)layoutIfNeededAllSuperViews;

@end
