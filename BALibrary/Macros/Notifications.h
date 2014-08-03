//
//  Notifications.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/2/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#ifndef BALibrary_Notifications_h
#define BALibrary_Notifications_h

#define declareNotificationWithName(identifier) \
    - (void) addObserver:(NSObject*)object For##identifier##NotificationWithSelector:(SEL)selector; \
    - (void) removeObserver:(NSObject*)object; \
    - (void) post##identifier##ChangeNotificationWithObject:(NSObject*)object

#define defineNotificationwithName(identifier) \
    - (void) addObserver:(NSObject*)object For##identifier##NotificationWithSelector:(SEL)selector; \
    { \
        [notifications addObserver:object selector:selector name:@#identifier object:nil]; \
    } \
    - (void) removeObserver:(NSObject*)object \
    { \
        [notifications removeObserver:object]; \
    } \
    - (void) post##identifier##ChangeNotificationWithObject:(NSObject*)object \
    { \
        [notifications postNotificationName:@#identifier object:object]; \
    }

#endif
