//
//  BALocationManager.m
//  BALibrary
//
//  Created by Salvador Guerrero on 8/15/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "BALocationManager.h"

@implementation BALocationManager
{
    NSMutableArray  *_listeners;
}

defineSingletonClass(BALocationManager);

- (id)init
{
    if ((self = [super init]))
    {
        self.delegate = self;
        _listeners = [NSMutableArray new];
        self.activityType = CLActivityTypeAutomotiveNavigation;
    }

    return self;
}

- (void)addListener:(id<CLLocationManagerDelegate>)listener
{
    if (!listener || ![listener conformsToProtocol:@protocol(CLLocationManagerDelegate)])
    {
        return;
    }

    [_listeners addObject:listener];

    /*
     * Calling startUpdatingLocation several times in succession does not automatically result in new events being generated.
     * Calling stopUpdatingLocation in between, however, does cause a new initial event to be sent the next time you call startUpdatingLocation method.
     */

    [self startUpdatingLocation];

    //don't pause automatically
    
    self.pausesLocationUpdatesAutomatically = NO;
}

- (void)removeListener:(id<CLLocationManagerDelegate>)listener
{
    [_listeners removeObject:listener];

    if (!_listeners.count)
    {
        [self stopUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (id<CLLocationManagerDelegate> listener in _listeners)
    {
        [listener locationManager:manager didUpdateLocations:locations];
    }
}

@end
