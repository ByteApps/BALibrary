//
//  MKMapItem+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 8/11/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "MKMapItem+BAExtension.h"

@implementation MKMapItem (BAExtension)

- (CLLocationCoordinate2D)coordinate
{
    return self.placemark.coordinate;
}

/*
 // MKPlacemark address dictionary properties
 @property (nonatomic, readonly) NSString *name; // eg. Apple Inc.
 @property (nonatomic, readonly) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
 @property (nonatomic, readonly) NSString *subThoroughfare; // eg. 1
 @property (nonatomic, readonly) NSString *locality; // city, eg. Cupertino
 @property (nonatomic, readonly) NSString *subLocality; // neighborhood, common name, eg. Mission District
 @property (nonatomic, readonly) NSString *administrativeArea; // state, eg. CA
 @property (nonatomic, readonly) NSString *subAdministrativeArea; // county, eg. Santa Clara
 @property (nonatomic, readonly) NSString *postalCode; // zip code, eg. 95014
 @property (nonatomic, readonly) NSString *ISOcountryCode; // eg. US
 @property (nonatomic, readonly) NSString *country; // eg. United States
 @property (nonatomic, readonly) NSString *inlandWater; // eg. Lake Tahoe
 @property (nonatomic, readonly) NSString *ocean; // eg. Pacific Ocean
 @property (nonatomic, readonly) NSArray *areasOfInterest; // eg. Golden Gate Park

 */

- (NSString *)name
{
    NSString *name = self.placemark.name;

    if (!name)
    {
        return @"";
    }

    return name;
}

- (NSString *)fullAddress
{
    return [NSString stringWithFormat:@"%@, %@ %@, %@ %@", self.fullStreetAddress, self.city, self.state, self.countryCode, self.postalCode];
}

- (NSString *)fullStreetAddress
{
    return [NSString stringWithFormat:@"%@ %@", self.streetNumber, self.streetAddress];
}

- (NSString *)streetNumber
{
    NSString *result = self.placemark.subThoroughfare;

    if (!result)
    {
        return @"";
    }

    return result;
}

- (NSString *)streetAddress;
{
    NSString *result = self.placemark.thoroughfare;

    if (!result)
    {
        return @"";
    }

    return result;
}

- (NSString *)city
{
    NSString *result = self.placemark.locality;

    if (!result)
    {
        return @"";
    }

    return result;
}

- (NSString *)state
{
    NSString *result = self.placemark.administrativeArea;

    if (!result)
    {
        return @"";
    }

    return result;
}

- (NSString *)postalCode
{
    NSString *result = self.placemark.postalCode;

    if (!result)
    {
        return @"";
    }

    return result;
}

- (NSString *)countryCode
{
    NSString *result = self.placemark.ISOcountryCode;

    if (!result)
    {
        return @"";
    }

    return result;
}

@end
