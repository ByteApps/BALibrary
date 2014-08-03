//
//  NSString+Extension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 7/8/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BAExtension)

#pragma mark encryptation methods

//Will return a Base64 encoded string

- (NSString *)AES256EncryptWithKey:(NSString *)key;

//String must be Base64 Encoded

- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end
