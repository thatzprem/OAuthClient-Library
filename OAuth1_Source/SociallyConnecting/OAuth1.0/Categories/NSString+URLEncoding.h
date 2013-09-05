//
//  NSString+URLEncoding.h
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.


#import <Foundation/Foundation.h>


@interface NSString (OAURLEncodingAdditions)

- (NSString *)encodedURLString;
- (NSString *)encodedURLParameterString;
- (NSString *)decodedURLString;
- (NSString *)removeQuotes;
@end
