//
//  UIImage+Extension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 7/7/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BAExtension)

- (UIImage *)imageWithTintedOverlayColor:(UIColor *)color withIntensity:(float)alpha;

@end
