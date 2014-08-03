//
//  MKMapView+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 7/1/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "MKMapView+BAExtension.h"

@implementation MKMapView (BAExtension)

- (struct BorderCoordinates)borderCoordinates
{
    //reference: http://stackoverflow.com/questions/6118109/get-mapkit-view-border-coordinates

    MKCoordinateRegion region = self.region;

    double minLat = region.center.latitude - (region.span.latitudeDelta / 2.0);
    double maxLat = region.center.latitude + (region.span.latitudeDelta / 2.0);

    double minLong = region.center.longitude - (region.span.longitudeDelta / 2.0);
    double maxLong = region.center.longitude + (region.span.longitudeDelta / 2.0);

    //parse doesn't like whole numbers :/
#define ErrGap (0.1)

    maxLat = MIN(maxLat, (90 - ErrGap));
    minLat = MAX(minLat, (-90 + ErrGap));

    maxLong = MIN(maxLong, (180 - ErrGap));
    minLong = MAX(minLong, (-180 + ErrGap));

    struct BorderCoordinates result;

    result.northeast = CLLocationCoordinate2DMake(maxLat, maxLong);
    result.southwest = CLLocationCoordinate2DMake(minLat, minLong);

    return result;
}

@end


BOOL existingAnnocation(NSArray *items, id<MKAnnotation> annotation)
{
    for (id<MKAnnotation> item in items)
    {
        if ([item coordinate].latitude == [annotation coordinate].latitude && [item coordinate].longitude == [annotation coordinate].longitude)
        {
            return YES;
        }
    }
    return NO;
}