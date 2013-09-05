//
//  OAuthConsumer.h
//  oAuth1.0Client
//
//  Created by myCompany on 16/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthConsumer : NSObject


@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *realm;

-(id) initWithConsumerIdentifier:(NSString *)identifier withSecretKey:(NSString *)secreteKey withRealm:(NSString *)realm;

@end
