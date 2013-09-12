//
//  GoogleConnector.m
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 17/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import "GoogleDriveConnector.h"

#import "OAuth2Client.h"
#import "OAuth2ClientDelegate.h"
#import "NSDictionary+QueryString.h"


//https://www.googleapis.com/oauth2/v2/userinfo?access_token=ya29.AHES6ZRxPAcb4WznwIcbN69tAM28ctPMDjrVtOg6KyuCVmTZIWWG3Q



#define kHostName @"https://www.googleapis.com/drive/v2"
//#define kAbout @""
//#define kFriendsList @"users/self/followed-by"
//#define kPhotosList @"users/self/media/recent"


@interface GoogleDriveConnector()<OAuth2ClientDelegate>{
    
    OAuth2Client *oAuthClient;
    NSString *resourcePath;
    NSString *accessTokenString;
    NSString *googleUserID;
    
}

@end

@implementation GoogleDriveConnector



- (id)initWithAuthorizingWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        
        oAuthClient = [[OAuth2Client alloc] initOAuth2ClientComponentWithConfigFileName:@"GoogleDriveOAuth2ClientConfig"];
        oAuthClient.delegate = self;
        
        NSError *error;
        [oAuthClient authorizeUsingWebView:webView errorObject:&error];
        
        NSLog(@"ERROR: %@",error);
    }
    return self;
}


- (NSURL*)getDataForGoogleDriveAPI:(GOOGLE_DRIVE_USER_API)api
{
    
    resourcePath = [self getResourcePathForAPI:api];
    
    if (!accessTokenString) {

        NSLog(@"Access token is nil...");
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
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v2/userinfo?access_token=%@",accessTokenString]];

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
    
    googleUserID = [json objectForKey:@"id"];
    
    
    NSLog(@"googleUserID: %@", googleUserID);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"googleDriveSuccessNotification" object:nil];

        
    
}
- (void)oauthClientDidRefreshAccessToken:(OAuth2Client *)client{
    
//    NSString *accessTokenString = [NSString stringWithFormat:@"%@",client.accessToken];
//    NSLog(@"Refreshed Token string = %@",accessTokenString);
    
}


- (NSString *)getResourcePathForAPI:(GOOGLE_DRIVE_USER_API)iApi {
	NSMutableString *aString;
	
	switch (iApi) {
            
			
		case GOOGLE_DRIVE_USER_CHANGES:
			aString = [NSMutableString stringWithString:@"changes"];
			break;
			
		case GOOGLE_DRIVE_USER_ABOUT:
			aString = [NSMutableString stringWithString:@"about"];
			break;
			
		case GOOGLE_DRIVE_USER_APPS:
			aString = [NSMutableString stringWithString:@"apps"];
			break;
			
		default:
			break;
	}
	
	return aString;
}

@end
