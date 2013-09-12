//
//  SocialConnectorFaceBookHandler.m
//  SocialConnector
//
//  Created by Testing on 25/04/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import "FaceBookConnector.h"
#import "OAuth2Client.h"
#import "OAuth2ClientDelegate.h"
#import "NSDictionary+QueryString.h"


#define kHostName @"https://graph.facebook.com"
#define kUserIndicator @"me"

@interface FaceBookConnector()<OAuth2ClientDelegate>{

        OAuth2Client *oAuthClient;
        NSString *resourcePath;
        NSString *accessTokenString;
}

@end

@implementation FaceBookConnector

- (id)initWithAuthorizingWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        
        
        oAuthClient = [[OAuth2Client alloc] initOAuth2ClientComponentWithConfigFileName:@"FacebookOAuth2ClientConfig"];
        oAuthClient.delegate = self;
        
        NSError *error;
        [oAuthClient authorizeUsingWebView:webView errorObject:&error];
        
        if (!error) {
            NSLog(@"ERROR: %@",error);
        }
    }
    return self;
}
- (NSURL*)getDataForFaceBookAPI:(FACEBOOK_USER_API)api
{
    resourcePath = [self getResourcePathForAPI:api];
    
    if (!accessTokenString) {
//        [[HMLogManager getSharedInstance] error:@"Access Token is nil..."];
        
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kHostName,resourcePath]];
    NSLog(@"%@",url);
    
    NSDictionary *accessCodeParams = [NSMutableDictionary dictionary];
    [accessCodeParams setValue:accessTokenString forKey:@"access_token"];
    
    NSString *urlString = [[url absoluteString] stringByAppendingFormat:@"?access_token=%@",accessTokenString];
    
    NSURL *fullURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"API URL = %@",fullURL);
    
    return fullURL;
    

}

- (void)oauthClientDidReceiveAccessToken:(OAuth2AccessToken *)client{
    
    accessTokenString = [NSString stringWithFormat:@"%@",client];
    NSLog(@"access Token string = %@",accessTokenString);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookSuccessNotification" object:nil];

    
}
- (void)oauthClientDidRefreshAccessToken:(OAuth2Client *)client{
    
    NSString *accessTokenString = [NSString stringWithFormat:@"%@",client.accessToken];
    NSLog(@"Refreshed Token string = %@",accessTokenString);
    
}


- (NSString *)getResourcePathForAPI:(FACEBOOK_USER_API)iApi {
	NSMutableString *aString;
	
	switch (iApi) {
    
			
		case FACEBOOK_USER_FRIENDS:
			aString = [NSMutableString stringWithFormat:@"%@/%@", kUserIndicator, @"friends"];
			break;
			
		case FACEBOOK_USER_ABOUT:
			aString = [NSMutableString stringWithFormat:@"%@", kUserIndicator];
			break;
			
		case FACEBOOK_USER_PHOTOS:
			aString = [NSMutableString stringWithFormat:@"%@/%@", kUserIndicator, @"photos"];
			break;
			
		default:
			break;
	}
	
	return aString;
}

@end
