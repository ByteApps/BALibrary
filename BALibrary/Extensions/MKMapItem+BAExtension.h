//
//  MKMapItem+BAExtension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/11/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapItem (BAExtension)

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) NSString    *fullStreetAddress;
@property (nonatomic, readonly) NSString    *streetNumber;
@property (nonatomic, readonly) NSString    *streetAddress;
@property (nonatomic, readonly) NSString    *city;
@property (nonatomic, readonly) NSString    *state;
@property (nonatomic, readonly) NSString    *postalCode;
@property (nonatomic, readonly) NSString    *countryCode;

@end
