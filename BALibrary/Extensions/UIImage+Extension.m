//
//  UIImage+Extension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 7/7/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (BAExtension)

//Reference 1: http://stackoverflow.com/questions/1698971/uiimage-color-changing
//Reference 2: http://coffeeshopped.com/2010/09/iphone-how-to-dynamically-color-a-uiimage

- (UIImage *)imageWithTintedOverlayColor:(UIColor *)color withIntensity:(float)alpha
{
    CGSize size = self.size;
    CGRect rect = CGRectMake(CGPointZero.x, CGPointZero.y, self.size.width, self.size.height);

    UIGraphicsBeginImageContextWithOptions(size, FALSE, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];

    // translate/flip the graphics context (for transforming from CG* coords to UI* coords

    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, alpha);

    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle

    CGContextClipToMask(context, rect, self.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);

    UIImage * tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

@end
