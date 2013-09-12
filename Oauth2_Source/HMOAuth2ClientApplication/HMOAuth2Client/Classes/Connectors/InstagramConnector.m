//
//  InstagramConnector.m
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 15/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import "InstagramConnector.h"
#import "OAuth2Client.h"
#import "OAuth2ClientDelegate.h"
#import "NSDictionary+QueryString.h"


#define kHostName @"https://api.instagram.com"
#define kUserIndicator @"v1"
#define kFriendsList @"users/self/followed-by"

#define kPhotosList @"users/self/media/recent"
@interface InstagramConnector()<OAuth2ClientDelegate>{
    
    OAuth2Client *oAuthClient;
    NSString *resourcePath;
    NSString *accessTokenString;

}

@end

@implementation InstagramConnector



- (id)initWithAuthorizingWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        
        
        oAuthClient = [[OAuth2Client alloc] initOAuth2ClientComponentWithConfigFileName:@"InstagramOAuth2ClientConfig"];
        oAuthClient.delegate = self;
        
        NSError *error;
        [oAuthClient authorizeUsingWebView:webView errorObject:&error];
        
        NSLog(@"ERROR: %@",error);
    }
    return self;
}


- (NSURL*)getDataForinstagramAPI:(INSTAGRAM_USER_API)api
{
    
    resourcePath = [self getResourcePathForAPI:api];
    
    if (!accessTokenString) {
        
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
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"instagramSuccessNotification" object:nil];

    
}
- (void)oauthClientDidRefreshAccessToken:(OAuth2Client *)client{
    
    NSString *accessTokenString = [NSString stringWithFormat:@"%@",client.accessToken];
    NSLog(@"Refreshed Token string = %@",accessTokenString);
    
}


- (NSString *)getResourcePathForAPI:(INSTAGRAM_USER_API)iApi {
	NSMutableString *aString;
	
	switch (iApi) {
            
			
		case INSTAGRAM_USER_FRIENDS:
			aString = [NSMutableString stringWithFormat:@"%@/%@", kUserIndicator, kFriendsList];
			break;
			
		case INSTAGRAM_USER_ABOUT:
			aString = [NSMutableString stringWithFormat:@"%@/users/self", kUserIndicator];
			break;
			
		case INSTAGRAM_USER_PHOTOS:
			aString = [NSMutableString stringWithFormat:@"%@/%@", kUserIndicator, kPhotosList];
			break;
			
		default:
			break;
	}
	
	return aString;
}

@end
