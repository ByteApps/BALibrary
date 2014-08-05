//
//  NSOperationQueue+BAExtension.m
//  Pods
//
//  Created by Salvador Guerrero on 8/4/14.
//
//

#import "NSOperationQueue+BAExtension.h"

@implementation NSOperationQueue (BAExtension)

+ (id)backgroundQueue
{
    static NSOperationQueue *_backgroundQueue = nil;

    if (!_backgroundQueue)
    {
        _backgroundQueue = [NSOperationQueue new];
    }

    return _backgroundQueue;
}

@end
