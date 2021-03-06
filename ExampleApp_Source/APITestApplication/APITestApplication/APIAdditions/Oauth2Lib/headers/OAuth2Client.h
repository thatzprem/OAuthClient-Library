//
//  OAuth2Client.h
//  OAuth2Client
//
/**
 Created by Prem on 12/03/13.
 Copyright (c) 2013 NexTip Solutions
 This program is not to be copied or distributed without the express written consent of NexTip. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "LROAuth2ClientDelegate.h"
#import "LROAuth2ClientDelegate.h"

@class OAuth2AccessToken;


@interface OAuth2Client : NSObject {
    
    
/**
 The clientID for the applcation on a service provider.
 */
  NSString *clientID;
    
/**
 The clientSecret for the applcation on a service provider.
 */
  NSString *clientSecret;
    
/**
 The RedirectURL for the applcation on a service provider.
 */
  NSURL *redirectURL;
    
/**
 The CancelURL for the applcation as provided by the service provider.
 */
  NSURL *cancelURL;
    
/**
 The AuthorizationURL for the applcation to redirect the user to serviceProvider login screen for provide User credentials.
 */
  NSURL *userURL;
    
/**
 The Access token URL to exchange the access code for the access token from the service provider.
 */
  NSURL *tokenURL;
    
/**
 The Access token class to process the access token parameters.
 */
  OAuth2AccessToken *accessToken;

/**
 An array that holds the requests.
 */
  NSMutableArray *requests;
    
/**
 Delegate to notify the user with delegate methods
 */
  id<OAuth2ClientDelegate> __unsafe_unretained delegate;
    
/**
 Debug mode for the library.
 */
  BOOL debug;
  
 @private
/**
 Bool to track and don't allow more than one auth request
 */
  BOOL isVerifying;
}
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, strong) NSURL *redirectURL;
@property (nonatomic, copy) NSURL *cancelURL;
@property (nonatomic, copy) NSURL *userURL;
@property (nonatomic, copy) NSURL *tokenURL;
@property (nonatomic, readonly) OAuth2AccessToken *accessToken;
@property (nonatomic, unsafe_unretained) id<OAuth2ClientDelegate> delegate;
@property (nonatomic, assign) BOOL debug;

/**
 1. Initialize the OAuth component with the details of the HMOAuth2ClientConfig dictionary.
 2. Set the class properties with the values of the dictionary.
 @return retun the self contained class object.
 */
- (id)initOAuth2ClientComponentWithConfigFileName:(NSString*)confFileName;


/**
 Method forming the access code request that can be loaded to a webview.
 @return URLRequest, that can be loaded to a webview.
 */
- (NSURLRequest *)getAccessCodeRequest;

/**
 Method to get the config file data and details as a NSDictionary.
 @return NSDictionary, values of the config plist file details as a NSDictionary.
 */
- (NSDictionary *)getConfigurationPlistData:(NSString*)confFileNameString;

/**
 Method to exchange the access code for Access token.
 @param accessCode, as a NSString.
 @return nil
 */
- (void)verifyAuthorizationWithAccessCode:(NSString *)accessCode;

/**
 Method to refresh the Access token.
 @param1 _accessToken.
 @param2 additionalParameters
 @param3 serviceProvider
 @return nil
 */
- (void)refreshAccessToken:(OAuth2AccessToken *)_accessToken additionalParameters:(NSDictionary *)additionalParameters serviceProviderID:(int)serviceProvider;
@end

@interface OAuth2Client (UIWebViewIntegration) <UIWebViewDelegate>

/**
 Method to receive the webView from the application
 @param Webview, receive a webview instance.
 @return nil
 */
- (void)authorizeUsingWebView:(UIWebView *)webView errorObject:(NSError **)error;

/**
 Method to add any new additional params required to form a access code request.
 @param Webview, receive a webview instance.
 @param additionalParameters, that may be required for access code request.
 @return nil
 */
- (void)authorizeUsingWebView:(UIWebView *)webView additionalParameters:(NSDictionary *)additionalParameters;

/**
 Method to extract the access code from call back URL
 @param url, the call back URL.
 @return nil
 */
- (void)extractAccessCodeFromCallbackURL:(NSURL *)url;
@end
