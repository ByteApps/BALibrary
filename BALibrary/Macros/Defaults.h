//
//  Defaults.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/2/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#ifndef BALibrary_Defaults_h
#define BALibrary_Defaults_h

#define declareEnumProperty(type, name) \
    declareNotificationWithName(name); \
    @property (nonatomic, assign) type name

#define defineApplicationSettingsEnumProperty(type, name, defaultValue) \
    defineNotificationwithName(name) \
    @dynamic name; \
    - (type)name \
    { \
        id object = [defaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return (type)[object intValue]; \
    } \
    - (void)set##name:(type)newValue \
    { \
        [defaults setInteger:newValue forKey:@#name]; \
        [defaults synchronize]; \
        [self post##name##ChangeNotificationWithObject:[NSNumber numberWithInteger:newValue]]; \
    } \

#endif
