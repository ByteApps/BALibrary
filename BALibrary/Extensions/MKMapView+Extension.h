//
//  MKMapView+Extension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 7/1/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <MapKit/MapKit.h>

struct BorderCoordinates
{
    CLLocationCoordinate2D  northeast;
    CLLocationCoordinate2D  southwest;
};

@interface MKMapView (BAExtension)

- (struct BorderCoordinates)borderCoordinates;

@end

extern BOOL existingAnnocation(NSArray *items, id<MKAnnotation> annotation);
