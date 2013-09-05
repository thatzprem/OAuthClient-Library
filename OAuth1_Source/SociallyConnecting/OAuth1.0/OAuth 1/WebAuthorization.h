//
//  WebAuthorization.h
//  SociallyConnecting
//
//  Created by myCompany on 22/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthAccessToken.h"

@protocol webAuthorizedDelegate <NSObject>

- (void) loadedSuccesfully:(OAuthAccessToken *)requestToken;

@end

@interface WebAuthorization : NSObject <UIWebViewDelegate>
@property (nonatomic,strong) id <webAuthorizedDelegate> delegate;

@property (nonatomic,strong) NSString *authorizedUrl;
@property (nonatomic,strong) OAuthAccessToken *requestToken;


@end
