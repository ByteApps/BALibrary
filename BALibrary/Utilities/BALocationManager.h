//
//  BALocationManager.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/15/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

/* BALocationManager
 *
 * Currently location manager starts updating location when at least one listener is added,
 * it will automatically stop location updates when all listeners are removed.
 */

@interface BALocationManager : CLLocationManager <CLLocationManagerDelegate>

declareSingletonClass(BALocationManager);

- (void)addListener:(id<CLLocationManagerDelegate>)listener;
- (void)removeListener:(id<CLLocationManagerDelegate>)listener;

@end
