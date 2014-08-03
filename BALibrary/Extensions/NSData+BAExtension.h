//
//  NSData+BAExtension.h
//  BALibrary
//
//  Created by Salvador Guerrero on 7/8/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//
//Reference: https://github.com/alexeypro/EncryptDecrypt/blob/master/NSData%2BAESCrypt.m

#import <Foundation/Foundation.h>

@interface NSData (BAExtension)

#pragma mark encryptation methods

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
