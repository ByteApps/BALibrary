//
//  UIAlertView+BAExtension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/23/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define showAlert(x) [[[[UIAlertView alloc] initWithTitle:nil message:x delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] autorelease] show]

@interface UIAlertView (BAExtension)

@end
