//
//  BADefaults.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/2/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#ifndef BALibrary_Defaults_h
#define BALibrary_Defaults_h


#define declareDefaultsReadOnlyProperty(type, name) \
    @property (nonatomic, readonly) type name

#define declareDefaultsProperty(type, name) \
    @property (nonatomic, assign) type name

#define declareDefaultsEnumProperty(type, name) \
    declareDefaultsProperty(type, name)

#define declareDefaultsBoolProperty(name) \
    declareDefaultsProperty(BOOL, name)

#define declareDefaultsReadOnlyBoolProperty(name) \
    declareDefaultsReadOnlyProperty(BOOL, name)

#define declareBundleBoolProperty(name) \
    declareDefaultsReadOnlyBoolProperty(name)

#define declareDefaultsInt32Property(name) \
    declareDefaultsProperty(Int32, name)

#define declareDefaultsUInt32Property(name) \
    declareDefaultsProperty(UInt32, name)

#define declareDefaultsInt64Property(name) \
    declareDefaultsProperty(Int64, name)

#define declareDefaultsUInt64Property(name) \
    declareDefaultsProperty(UInt64, name)

#define declareDefaultsFloatProperty(name) \
    declareDefaultsProperty(float, name)

#define declareDefaultsStringProperty(name) \
    declareDefaultsProperty(NSString *, name)

#define defineDefaultsBoolReadOnlyProperty(name, defaultValue) \
    - (BOOL)name \
    { \
        id object = [UserDefaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return [object boolValue]; \
    }

#define defineBundleBoolProperty(name, defaultValue) \
    defineDefaultsBoolReadOnlyProperty(name, defaultValue)


#define defineDefaultsEnumProperty(type, name, defaultValue) \
    @dynamic name; \
    - (type)name \
    { \
        id object = [UserDefaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return (type)[object intValue]; \
    } \
    - (void)set##name:(type)newValue \
    { \
        [UserDefaults setInteger:newValue forKey:@#name]; \
        [UserDefaults synchronize]; \
    } \

#define defineDefaultsBoolProperty(name, defaultValue) \
    @dynamic name; \
    - (BOOL)name \
    { \
        id object = [UserDefaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return [object boolValue]; \
    } \
    - (void)set##name:(BOOL)newValue \
    { \
        [UserDefaults setBool:newValue forKey:@#name]; \
        [UserDefaults synchronize]; \
    } \

#define defineDefaultsUInt64Property(name, defaultValue)\
    - (UInt64)name \
    { \
        id object = [UserDefaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return [object unsignedLongLongValue]; \
    } \
    - (void)set##name:(UInt64)value \
    { \
        [UserDefaults setObject:[NSNumber numberWithUnsignedLongLong:value] forKey:@#name]; \
        [UserDefaults synchronize]; \
    }

#define defineDefaultsFloatProperty(name, defaultValue)\
    - (float)name { \
        id object = [UserDefaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return [object floatValue]; \
    } \
    -(void)set##name:(float)value \
    { \
        [UserDefaults setFloat:value forKey:@#name]; \
        [UserDefaults synchronize]; \
    }

#define defineDefaultsStringProperty(name, defaultValue)\
    - (NSString *)name { \
        id object = [UserDefaults objectForKey:@#name]; \
        if (!object) return defaultValue; \
        return object; \
    } \
    - (void)set##name:(NSString *)value \
    { \
        [UserDefaults setObject:value forKey:@#name]; \
        [UserDefaults synchronize]; \
    }

#endif
