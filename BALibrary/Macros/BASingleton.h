//
//  BASingleton.h
//  BALibrary
//
//  Created by Salvador Guerrero on 8/2/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#ifndef BALibrary_Singleton_h
#define BALibrary_Singleton_h

#define declareSingletonClass(className) \
    + (className*)sharedInstance;

#define defineSingletonClass(className) \
    className *_sharedInstance##className = nil; \
    \
    + (void)load \
    { \
        _sharedInstance##className = [className new]; \
    } \
    \
    + (className*)sharedInstance \
    { \
        return  _sharedInstance##className; \
    } \
    - (id)retain { return  _sharedInstance##className; } \
    - (oneway void)release {} \
    - (id)autorelease { return  _sharedInstance##className; } \
    - (NSUInteger)retainCount { return NSUIntegerMax; }

#endif
