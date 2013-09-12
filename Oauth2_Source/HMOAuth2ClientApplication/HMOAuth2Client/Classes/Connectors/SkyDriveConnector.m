//
//  SkyDriveConnector.m
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 05/09/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import "SkyDriveConnector.h"
#import "OAuth2Client.h"
#import "OAuth2ClientDelegate.h"
#import "NSDictionary+QueryString.h"


#define kHostName @"https://apis.live.net/v5.0/me/skydrive/quota?"

@interface SkyDriveConnector()<OAuth2ClientDelegate>{
    
    OAuth2Client *oAuthClient;
    NSString *resourcePath;
    NSString *accessTokenString;
    NSString *skyDriveID;
    
}

@end


@implementation SkyDriveConnector

- (id)initWithAuthorizingWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        
        
        oAuthClient = [[OAuth2Client alloc] initOAuth2ClientComponentWithConfigFileName:@"SkyDriveOAuth2ClientConfig"];
        oAuthClient.delegate = self;
        
        NSError *error;
        [oAuthClient authorizeUsingWebView:webView errorObject:&error];
        
        NSLog(@"ERROR: %@",error);
    }
    return self;
}


- (NSURL*)getDataForSkyDriveAPI:(SKYDRIVE_USER_API)api
{
    
//    resourcePath = [self getResourcePathForAPI:api];
    
    
    if (!accessTokenString) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kHostName]];
    NSLog(@"%@",url);
    
    NSDictionary *accessCodeParams = [NSMutableDictionary dictionary];
    [accessCodeParams setValue:accessTokenString forKey:@"access_token"];
    
    NSString *urlString = [[url absoluteString] stringByAppendingFormat:@"access_token=%@",accessTokenString];
    
    NSURL *fullURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"API URL = %@",url);
    
    return fullURL;
    
    
}

- (void)oauthClientDidReceiveAccessToken:(OAuth2AccessToken *)client{
    
    accessTokenString = [NSString stringWithFormat:@"%@",client];
    NSLog(@"access Token string = %@",accessTokenString);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://apis.live.net/v5.0/me/skydrive/quota?access_token=%@",accessTokenString]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    
    NSDictionary *json =
    [NSJSONSerialization JSONObjectWithData:urlData
                                    options:kNilOptions
                                      error:&error];
    NSLog(@"Received Json UserID data  = %@",json);
    
    skyDriveID = [json objectForKey:@"id"];
    
    
    NSLog(@"skyDriveID: %@", skyDriveID);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skyDriveSuccessNotification" object:nil];
    
    
    
}
- (void)oauthClientDidRefreshAccessToken:(OAuth2Client *)client{
    
    //    NSString *accessTokenString = [NSString stringWithFormat:@"%@",client.accessToken];
    //    NSLog(@"Refreshed Token string = %@",accessTokenString);
    
}


- (NSString *)getResourcePathForAPI:(SKYDRIVE_USER_API)iApi {
	NSMutableString *aString;
	
	switch (iApi) {
            
			
		case SKYDRIVE_USER_CHANGES:
            
			aString = [NSMutableString stringWithString:@"user/113147664993405565981/albumid/5654736637546511265"];
			break;
			
		case SKYDRIVE_USER_ABOUT:
			aString = [NSMutableString stringWithString:@"user/113147664993405565981"];
			break;
			
		case SKYDRIVE_USER_APPS:
			aString = [NSMutableString stringWithString:@"apps"];
			break;
			
		default:
			break;
	}
	
	return aString;
}

@end
