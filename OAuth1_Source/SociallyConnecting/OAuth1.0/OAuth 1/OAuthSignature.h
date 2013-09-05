//
//  OAuthSignature.h
//  oAuth1.0Client
//
//  Created by myCompany on 16/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthSignature : NSObject

- (NSString *)name;
- (NSString *) hashedValue :(NSString *) key andMessage: (NSString *) message;

@end
