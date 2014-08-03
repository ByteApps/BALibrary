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
    className *_sharedInstance; \
    \
    + (void)load \
    { \
        _sharedInstance = [className new]; \
    } \
    \
    + (className*)sharedInstance \
    { \
        return  _sharedInstance; \
    }

#endif
