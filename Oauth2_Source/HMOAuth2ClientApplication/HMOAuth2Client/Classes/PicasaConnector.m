//
//  GoogleConnector.m
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 17/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import "PicasaConnector.h"

#import "OAuth2Client.h"
#import "LROAuth2ClientDelegate.h"
#import "NSDictionary+QueryString.h"


//https://www.googleapis.com/oauth2/v2/userinfo?access_token=ya29.AHES6ZRxPAcb4WznwIcbN69tAM28ctPMDjrVtOg6KyuCVmTZIWWG3Q



#define kHostName @"https://picasaweb.google.com/data/feed/api"
//#define kAbout @""
//#define kFriendsList @"users/self/followed-by"
//#define kPhotosList @"users/self/media/recent"


@interface PicasaConnector()<OAuth2ClientDelegate>{
    
    OAuth2Client *oAuthClient;
    NSString *resourcePath;
    NSString *accessTokenString;
    NSString *googleUserID;
    
}

@end

@implementation PicasaConnector



- (id)initWithAuthorizingWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        
        
        oAuthClient = [[OAuth2Client alloc] initOAuth2ClientComponentWithConfigFileName:@"PicasaOAuth2ClientConfig"];
        oAuthClient.delegate = self;
        
        NSError *error;
        [oAuthClient authorizeUsingWebView:webView errorObject:&error];
        
        NSLog(@"ERROR: %@",error);
    }
    return self;
}


- (NSURL*)getDataForPicasaAPI:(PICASA_USER_API)api
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
    
    NSLog(@"API URL = %@",url);
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"picasaSuccessNotification" object:nil];

        
    
}
- (void)oauthClientDidRefreshAccessToken:(OAuth2Client *)client{
    
//    NSString *accessTokenString = [NSString stringWithFormat:@"%@",client.accessToken];
//    NSLog(@"Refreshed Token string = %@",accessTokenString);
    
}


- (NSString *)getResourcePathForAPI:(PICASA_USER_API)iApi {
	NSMutableString *aString;
	
	switch (iApi) {
            
			
		case PICASA_USER_CHANGES:
            
            //https://picasaweb.google.com/data/feed/api/user/113147664993405565981/albumid/5654736637546511265
			aString = [NSMutableString stringWithString:@"user/113147664993405565981/albumid/5654736637546511265"];
			break;
			
		case PICASA_USER_ABOUT:
			aString = [NSMutableString stringWithString:@"user/113147664993405565981"];
			break;
			
		case PICASA_USER_APPS:
			aString = [NSMutableString stringWithString:@"apps"];
			break;
			
		default:
			break;
	}
	
	return aString;
}

@end
