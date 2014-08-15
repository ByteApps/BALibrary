//
//  BADefaults.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/2/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#ifndef BALibrary_Defaults_h
#define BALibrary_Defaults_h

#define declareEnumProperty(type, name) \
    @property (nonatomic, assign) type name

#define defineApplicationSettingsEnumProperty(type, name, defaultValue) \
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
    } \

#define declareBoolProperty(name) \
    @property (nonatomic, assign) BOOL name

#define defineApplicationSettingsBoolProperty(name, defaultValue) \
    @dynamic name; \
    - (BOOL)name \
    { \
        id object = [defaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return [object boolValue]; \
    } \
    - (void)set##name:(BOOL)newValue \
    { \
        [defaults setBool:newValue forKey:@#name]; \
        [defaults synchronize]; \
    } \

#endif
