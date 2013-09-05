//
//  OAuthConsumer.m
//  oAuth1.0Client
//
//  Created by myCompany on 16/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "OAuthConsumer.h"

@implementation OAuthConsumer

-(id) initWithConsumerIdentifier:(NSString *)identifier withSecretKey:(NSString *)secreteKey withRealm:(NSString *)realm
{
    self = [super init];
    
    if(self)
    {
        self.identifier = identifier;
        self.secret = secreteKey;
        self.realm = realm;
    }
    
    return self;
}

@end
