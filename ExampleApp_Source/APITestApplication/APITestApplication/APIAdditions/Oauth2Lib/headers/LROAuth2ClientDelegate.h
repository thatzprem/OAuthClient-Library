//
//  OAuth2ClientDelegate.h
//  OAuth2Client
//
/**
 Created by Prem on 12/03/13.
 Copyright (c) 2013 NexTip Solutions
 This program is not to be copied or distributed without the express written consent of NexTip. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class OAuth2Client;
@class OAuth2AccessToken;

@protocol OAuth2ClientDelegate <UIWebViewDelegate>

@required
- (void)oauthClientDidReceiveAccessToken:(OAuth2AccessToken *)client;

@optional
- (void)oauthClientDidReceiveAccessCode:(OAuth2Client *)client;
- (void)oauthClientDidCancel:(OAuth2Client *)client;
- (void)oauthClientDidRefreshAccessToken:(OAuth2Client *)client;


@end
