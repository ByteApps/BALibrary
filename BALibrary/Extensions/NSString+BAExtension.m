//
//  NSString+BAExtension.m
//  BALibrary
//
//  Created by Salvador Guerrero on 7/8/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//

#import "NSString+BAExtension.h"
#import "NSData+BAExtension.h"

@implementation NSString (BAExtension)

#pragma mark encryptation methods

- (NSString *)AES256EncryptWithKey:(NSString *)key
{
    NSData *encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];

    return [encryptedData base64EncodedStringWithOptions:0];

}

- (NSString *)AES256DecryptWithKey:(NSString *)key
{
    NSData *encodedData = [[[NSData alloc] initWithBase64EncodedString:self options:0] autorelease];
    return [[[NSString alloc] initWithData:[encodedData AES256DecryptWithKey:key] encoding:NSUTF8StringEncoding] autorelease];
}

@end
