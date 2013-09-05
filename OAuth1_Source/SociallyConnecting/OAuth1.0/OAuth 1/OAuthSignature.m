//
//  OAuthSignature.m
//  oAuth1.0Client
//
//  Created by myCompany on 16/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "OAuthSignature.h"
#include "hmac.h"
#include "Base64Transcoder.h"

@implementation OAuthSignature

#define BLOCKSIZE 64

/*
 
 The following pseudocode demonstrates how HMAC may be implemented. Blocksize is 64 (bytes) when using one of the following hash functions: SHA-1, MD5, RIPEMD-128/160.[2]
 
 function hmac (key, message)
 if (length(key) > blocksize) then
 key = hash(key) // keys longer than blocksize are shortened
 end if
 if (length(key) < blocksize) then
 key = key ∥ [0x00 * (blocksize - length(key))] // keys shorter than blocksize are zero-padded ('∥' is concatenation)
 end if
 
 o_key_pad = [0x5c * blocksize] ⊕ key // Where blocksize is that of the underlying hash function
 i_key_pad = [0x36 * blocksize] ⊕ key // Where ⊕ is exclusive or (XOR)
 
 return hash(o_key_pad ∥ hash(i_key_pad ∥ message)) // Where '∥' is concatenation
 end function
 */
- (NSString *)name {
    return @"PLAIN_TEXT";
}

- (NSString *) hashedValue :(NSString *) key andMessage: (NSString *) message {
    
    
    NSData *secretData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [key dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length], (unsigned char *)[secretData bytes], [secretData length], result);
    
    //Base64 Encoding
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return base64EncodedResult;
    
}

@end
