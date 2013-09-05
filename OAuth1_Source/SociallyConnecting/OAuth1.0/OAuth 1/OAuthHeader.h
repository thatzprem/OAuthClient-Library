//
//  OAuthHeader.h
//  SociallyConnecting
//
//  Created by myCompany on 23/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "OAuthAccessToken.h"

@interface OAuthHeader : NSObject



@property (nonatomic,strong) OAuthAccessToken *accessToken;
@property (nonatomic,strong) OAuthConsumer *consumer;
@property (nonatomic,strong) NSString *callBackURl;

-(void) getHeaderForRequest:(NSMutableURLRequest *)request;


@end
