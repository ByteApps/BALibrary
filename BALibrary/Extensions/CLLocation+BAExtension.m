//
//  CLLocation+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 7/7/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

@implementation CLLocation (BAExtension)

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

@end
