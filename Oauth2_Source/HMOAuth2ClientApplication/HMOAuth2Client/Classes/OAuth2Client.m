//
//  OAuth2Client.m
//  OAuth2Client
//
/**
 Created by Prem on 12/03/13.
 Copyright (c) 2013 NexTip Solutions
 This program is not to be copied or distributed without the express written consent of NexTip. All rights reserved.
 */

#import "OAuth2Client.h"
#import "NSURL+QueryInspector.h"
#import "OAuth2AccessToken.h"
#import "OAuth2ClientURLRequestOperation.h"
#import "NSDictionary+QueryString.h"
#import "OAuth2AccessToken.h"
#import "PlistHelper.h"
#import "HMOAuthConstants.h"

#pragma mark -
//#define Test Test
@interface OAuth2Client()

/**
 NSDictionary object to hold the details of the config file in a dictionary format with in the application.
 */
@property(nonatomic,strong)NSDictionary *oAuthConfigDictionary;

/**
 Set the class properties with values available in the dictionary object.
 */
- (void)setClassPropertiesWithDictionaryValues;

/**
 initialization for the properties which do not take value from oAuthConfigDictionary. 
 */
- (void)initOtherClassProperties;

/**
 Method to create an instance of the accesstoken class and notify the respective delegate methods.
 @param authDataInDictionary, the Oauth response data converted as an dictionary
 @return, void
 */
- (void)createAccessTokenObjectAndNotifyDelegateMethod:(NSDictionary*)authDataInDictionary;


/**
 Method to check the if the webview received if not nil or empty.
 @param webView, the reveived web view from the application.
 @return BOOL, true if web is not nil and proper delegate is set. false otherwise.
 */
- (BOOL)webViewEmptyOrNilCheck:(UIWebView*)webView;

- (void)applicationDelegateSetCheck:(NSError **)error;



@end

@implementation OAuth2Client {
    
/**
 A build in objective C network class instance to manage the network related operations.
 */
  NSOperationQueue *_networkQueue;
    
}

@synthesize clientID;
@synthesize clientSecret;
@synthesize redirectURL;
@synthesize cancelURL;
@synthesize userURL;
@synthesize tokenURL;
@synthesize delegate;
@synthesize accessToken;
@synthesize debug;

@synthesize oAuthConfigDictionary;

#pragma mark Initialization


- (id)initOAuth2ClientComponentWithConfigFileName:(NSString*)confFileName{
    
    if (self = [super init]) {
        
        self.oAuthConfigDictionary = [[NSDictionary alloc] initWithDictionary:[self getConfigurationPlistData:confFileName] copyItems:YES];
        NSLog(@"OAuth configuration dictionary details: %@",self.oAuthConfigDictionary);
    
        [self setClassPropertiesWithDictionaryValues]; //Set the class properties with Dictionary values.
        [self initOtherClassProperties]; //Set other class properties.
        
    }
    return self;
}

- (void)initOtherClassProperties{
    
    requests = [[NSMutableArray alloc] init];
    debug = NO;
    _networkQueue = [[NSOperationQueue alloc] init];
    
    
}

- (void)dealloc;
{
    [_networkQueue cancelAllOperations];
}


#pragma mark Plist to Dictionary Configuration

- (NSDictionary *)getConfigurationPlistData:(NSString*)confFileNameString
{
//    
    NSLog(@"Getting details from configuration plist file...");
    
    PlistHelper *plistHelper  = [[PlistHelper alloc]init];
    BOOL result = FALSE;
    
    NSLog(@"Config file name: %@",confFileNameString);
    NSLog(@"Config file extention: %@",OAUTH2_CONFIG_FILE_EXTENSION);
    
    result = [plistHelper copyResourceToDocDir:confFileNameString andResourceType:OAUTH2_CONFIG_FILE_EXTENSION];
    
    if (result) NSLog(@"Copying resource file to the docs directory successfull...");
    else NSLog(@"Copying resource file to the docs directory failed...");
    
    //Get the plist details in a dictionary.
    NSDictionary *configurationDictionary = [NSDictionary dictionaryWithDictionary:[plistHelper getDatafromPlist:[NSString stringWithFormat:@"%@.%@",confFileNameString,OAUTH2_CONFIG_FILE_EXTENSION]]];
    
    //Logging plist data
    NSLog(@"OAUTH CONFIG FILE DETAILS: %@",configurationDictionary);
    
//    
    
    return configurationDictionary;
}


- (void)setClassPropertiesWithDictionaryValues
{
    
    NSLog(@"Setting class properties with dictionary values...");
    
    NSLog(@"Configuration dictionary values:%@",self.oAuthConfigDictionary);
            
    clientID        =   [self.oAuthConfigDictionary valueForKey:@"ClientID"];
    clientSecret    =   [self.oAuthConfigDictionary valueForKey:@"ClientSecret"];
    redirectURL     =   [NSURL URLWithString:[self.oAuthConfigDictionary valueForKey:@"RedirectURL"]];
    
    userURL         =   [NSURL URLWithString:[self.oAuthConfigDictionary valueForKey:@"UserURL"]];
    tokenURL        =   [NSURL URLWithString:[self.oAuthConfigDictionary valueForKey:@"TokenURL"]];;
    
    NSLog(@"Class property values after assigning from the dictionary");
    NSLog(@"ClientID:%@",self.clientID);
    NSLog(@"ClientSecret:%@",self.clientSecret);
    NSLog(@"RedirectURL:%@",self.redirectURL);
    NSLog(@"UserURL:%@",self.userURL);
    NSLog(@"TokenURL:%@",self.tokenURL);
    
    
    
}

#pragma mark -
#pragma mark Authorization

- (NSURLRequest *)getAccessCodeRequest
{
    
    NSLog(@"Forming Access code request...");
    NSDictionary *accessCodeParams = [NSMutableDictionary dictionary];
    
    //Retreive the Additional Access code request parameters from oAuthConfigDictionary
    NSDictionary *accessCodeAdditionalParamsDictionary = [self.oAuthConfigDictionary valueForKey:@"AccessTokenAdditionalParams"];
    
  [accessCodeParams setValue:clientID forKey:@"client_id"];
  [accessCodeParams setValue:[redirectURL absoluteString] forKey:@"redirect_uri"];

  
    //Below 3 lines parse the all the keys in accessCodeAdditionalParamsDictionary
    // And adds it to the accessCodeParams dictionary.
  if (accessCodeAdditionalParamsDictionary) {
    for (NSString *key in accessCodeAdditionalParamsDictionary) {
      [accessCodeParams setValue:[accessCodeAdditionalParamsDictionary valueForKey:key] forKey:key];
    }
  }
    
    NSLog(@"accessCodeAdditionalParamsDictionary details: %@",accessCodeAdditionalParamsDictionary);
    NSLog(@"AccessCodeParams formed= %@",accessCodeParams);
    
  NSURL *fullURL = [NSURL URLWithString:[[self.userURL absoluteString] stringByAppendingFormat:@"?%@", [accessCodeParams stringWithFormEncodedComponents]]];
  NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:fullURL];
  [authRequest setHTTPMethod:@"GET"];
    
    NSLog(@"AccessCode request full URL = %@",fullURL);
    NSLog(@"AccessCode request = %@",authRequest);
    
    
    
  return [authRequest copy];
}

#pragma mark Exchange for Access token

- (void)verifyAuthorizationWithAccessCode:(NSString *)accessCode;
{
    
    
    NSLog(@"Exchanging Access code for Access token...");
    
    NSDictionary *accessTokenAdditionalParams = [self.oAuthConfigDictionary valueForKey:@"ExchangeAccessTokenParams"];
    
  @synchronized(self) {
    if (isVerifying) return; // don't allow more than one auth request
    
    isVerifying = YES;
    
    NSDictionary *accessTokenParams = [NSMutableDictionary dictionary];
      
    [accessTokenParams setValue:clientID forKey:@"client_id"];
    [accessTokenParams setValue:clientSecret forKey:@"client_secret"];
    [accessTokenParams setValue:[redirectURL absoluteString] forKey:@"redirect_uri"];
    [accessTokenParams setValue:accessCode forKey:@"code"];
      
      
      //Below 3 lines parse the all the keys in accessTokenAdditionalParams
      //dictionary and add it to the accessTokenParams dictionary.
      if (accessTokenAdditionalParams) {
          for (NSString *key in accessTokenAdditionalParams) {
              [accessTokenParams setValue:[accessTokenAdditionalParams valueForKey:key] forKey:key];
          }
      }
    
      NSLog(@"accessTokenAdditionalParams details: %@",accessTokenAdditionalParams);
      NSLog(@"AccessCodeParams formed= %@",accessTokenParams);
      
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.tokenURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[[accessTokenParams stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
      
      NSLog(@"Access token request: %@",request);
      
    OAuth2ClientURLRequestOperation *operation = [[OAuth2ClientURLRequestOperation alloc] initWithURLRequest:request];

    __unsafe_unretained id blockOperation = operation;

    [operation setCompletionBlock:^{
      [self handleCompletionForAuthorizationRequestOperation:blockOperation];
    }];
      
    [_networkQueue addOperation:operation];
      
      
      
  }
}

#pragma mark Refresh Access Token

//TODO: Refresh access token feature implementation is in progress....
- (void)refreshAccessToken:(OAuth2AccessToken *)_accessToken additionalParameters:(NSDictionary *)additionalParameters serviceProviderID:(int)serviceProvider;
{

    
//    [[HMLogManager getSharedInstance] info:@"REFRESHING ACCESS TOKEN..."];
//    [[HMLogManager getSharedInstance] debugWithLoggableObject:_accessToken];
    
    
    //Forming the refresh POST URL.
    NSDictionary *params = [NSMutableDictionary dictionary];
  [params setValue:@"refresh_token" forKey:@"grant_type"];
  [params setValue:clientID forKey:@"client_id"];
  [params setValue:clientSecret forKey:@"client_secret"];
  [params setValue:[redirectURL absoluteString] forKey:@"redirect_uri"];
  [params setValue:_accessToken.refreshToken forKey:@"refresh_token"];

    if (additionalParameters) {
        for (NSString *key in additionalParameters) {
            [params setValue:[additionalParameters valueForKey:key] forKey:key];
        }
    }

        
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.tokenURL];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:[[params stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
    
//    [[HMLogManager getSharedInstance] debug:@"Refresh token request URL:%@",request];
    
  OAuth2ClientURLRequestOperation *operation = [[OAuth2ClientURLRequestOperation alloc] initWithURLRequest:request];
  
  __unsafe_unretained id blockOperation = operation;
  
  [operation setCompletionBlock:^{
    [self handleCompletionForAuthorizationRequestOperation:blockOperation];
  }];
  
  [_networkQueue addOperation:operation];
}


#pragma mark Response Handler Methods

- (void)handleCompletionForAuthorizationRequestOperation:(OAuth2ClientURLRequestOperation *)operation
{
    
    
    
    //Return if the operation object is nil.
    if (!operation) {
        
        NSLog(@"Received operation object is nil...");
        return;
    }

    NSHTTPURLResponse *response = [self getResponseObjectFromOperationObject:operation];
    
    //Check and return if the response data is nil.
    if (response == nil) {
        
        NSLog(@"Response object is nil...");
        return;
    }
    
    //Check and return if there is an connection error.
    if (operation.connectionError) {
        
        NSLog(@"Localized string for status code = %@",[NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]);
        NSLog(@"Connection error: %@",operation.connectionError);
        return;
    }
    
    //Check if the response is a success or failure response.
    if ([self isSuccessOrFailureResponse:response]) {
      
      NSDictionary *authDict;
      
      authDict = [self convertResponseDataToDictionary:operation];
      
        //Check if the dictionary has Access token parameter.
      if ([self checkForAccessTokenInDictionary:authDict])
          [self createAccessTokenObjectAndNotifyDelegateMethod:authDict]; //Create an access token object and notify delegate.
    }
    
    

}

//FIXME- define this method.
- (NSDictionary *)convertResponseDataToDictionary:(OAuth2ClientURLRequestOperation *)operationObject{
    
    NSDictionary *authData;
    
    @try {
        
        if ([self NSJSONSerializationDataParsing:operationObject])
            authData = [self NSJSONSerializationDataParsing:operationObject];
            
        else if ([self queryStringDecodeParsingMechanism:operationObject])
            authData = [self queryStringDecodeParsingMechanism:operationObject];
        else
            NSLog(@"Both Parser mechanism failed...");

    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in parsing the response data...");
    }
    @finally {
        
        return authData;
    }

}

//FIXME- define this method.
- (NSHTTPURLResponse*)getResponseObjectFromOperationObject:(OAuth2ClientURLRequestOperation *)receivedOperationObject{
    
    NSLog(@"Received Operation Object: %@",receivedOperationObject);
    
    NSHTTPURLResponse *response;
    
    @try {
        
        response = (NSHTTPURLResponse *)receivedOperationObject.URLResponse;
        NSLog(@"Response code status: %d",response.statusCode);
        NSLog(@"Response header field: %@",response.allHeaderFields);
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception accessing the received response data with error :%@",[exception description]);
        response = nil; //Nullifying the response object incase of exceptions.
        
    }
    @finally {
        
        //return the response or else return nil;
        if (response)
            return response;
        else
            return nil;
    }
}
#pragma mark Response Parser methods

//FIXME- define this method.
- (NSDictionary*)NSJSONSerializationDataParsing:(OAuth2ClientURLRequestOperation *)operationObject{
    
    
    NSError *parserError;
    
    //Creating a dictionary object from JSON data.
    NSDictionary *authData = [NSJSONSerialization JSONObjectWithData:operationObject.responseData options:0 error:&parserError];
    
    if (authData)
        return authData;
    else
        return nil;

}

//FIXME- define this method.
- (NSDictionary*)queryStringDecodeParsingMechanism:(OAuth2ClientURLRequestOperation *)operationObject{
    
    
    NSString *responseString = [[NSString alloc] initWithData:operationObject.responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *authData = [NSDictionary dictionaryWithFormEncodedString:responseString];
    
    if (authData)
        return authData;
    else
        return nil;
    
}

//FIXME- define this method.
- (void)createAccessTokenObjectAndNotifyDelegateMethod:(NSDictionary*)authDataInDictionary{
    
    
    NSLog(@"Creating access token object and notifying the respective delegate methods...");
    NSLog(@"Received authDataInDictionary: %@",authDataInDictionary);
    
    if (accessToken == nil) {
        NSLog(@"Adding access token in acessToken object...");

        accessToken = [[OAuth2AccessToken alloc] initWithAuthorizationResponse:authDataInDictionary];
    
//        HMLogger_LogableObject_Debug(accessToken);
        
        if ([self.delegate respondsToSelector:@selector(oauthClientDidReceiveAccessToken:)]) {
            NSLog(@"Notifying through oauthClientDidReceiveAccessToken...");
            [self.delegate oauthClientDidReceiveAccessToken:accessToken.accessToken];
        }
    } else {
        NSLog(@"Updating access token in acessToken object...");
        //[accessToken refreshFromAuthorizationResponse:authData serviceProvider:serviceProviderID]; //Implementation in progress...
        if ([self.delegate respondsToSelector:@selector(oauthClientDidRefreshAccessToken:)]) {
            NSLog(@"Notifying through oauthClientDidRefreshAccessToken...");
            [self.delegate oauthClientDidRefreshAccessToken:self];
        }
    }
}

#pragma mark Response Status Check Methods

//FIXME- define this method.
- (BOOL)isSuccessOrFailureResponse:(NSHTTPURLResponse *)response{
    
    NSLog(@"Received response: %@",response);
    
    if (response.statusCode == ACCESS_TOKEN_SUCCESS_RESPONSE_STATUSCODE) {
        
        NSLog(@"Success response! Code: %d",response.statusCode);
        return TRUE;
    }
    else{
        
        NSLog(@"Failure response! Code: %d",response.statusCode);
        return FALSE;
    }
    
}

//FIXME- define this method.
-(BOOL)checkForAccessTokenInDictionary:(NSDictionary*)dictionary{
    
    BOOL status;
    
    if (dictionary) {
        
        if ([dictionary objectForKey:@"access_token"]) {
            NSLog(@"Access token value found...");
            status = TRUE;
        }
        else{
            NSAssert(NO, @"Unhandled parsing failure");
            NSLog(@"Parsing failure for key: access_token");
            status = FALSE;
        }
    }
    else
        status = FALSE;
    
    return status;

}

@end


@implementation OAuth2Client (UIWebViewIntegration)

#pragma mark Web View Integeration methods

- (void)authorizeUsingWebView:(UIWebView *)webView errorObject:(NSError **)error;
{
    

    [self applicationDelegateSetCheck:error]; // First check if the application delegate is set?
    
    if ([self webViewEmptyOrNilCheck:webView errorObject:error]) { //Check if a empty/nil web view is received?
        
        [self authorizeUsingWebView:webView additionalParameters:[self.oAuthConfigDictionary valueForKey:@"AccessTokenAdditionalParams"]]; // Calling other method with additional params details.
    }
        
    
}

#pragma mark WebView Validation Methods

- (BOOL)webViewEmptyOrNilCheck:(UIWebView*)webView errorObject:(NSError **)error{
    
    if (webView) {
        NSLog(@"Web view is not nil...");
        
        [webView setDelegate:self]; //Setting webview delegate.
        
        if (webView.delegate) {
            NSLog(@"Web view delegate is set...");
            return YES;
        }
        else{
            NSLog(@"Web view delegate is not set...");
            *error = [NSError errorWithDomain:@"Web view delegate is not set..." code:200 userInfo:nil];
            
            return NO;
        }
    }
    else{
        NSLog(@"Didn't receive any webview reference...");
        *error = [NSError errorWithDomain:@"Webview object found Invalid or unavilable for access!" code:201 userInfo:nil];

        return NO;
    }
}

- (void)applicationDelegateSetCheck:(NSError **)error{
    
    if (self.delegate) {
        
        NSLog(@"Application delegate is set to get the call back...");
    }
    else{
        
        NSLog(@"Application delegate is not set");
        
        NSLog(@"Applcation is not set... Returning with exception...");
        
        *error = [NSError errorWithDomain:@"Application delegate not set!" code:202 userInfo:nil];

    }
    
}

- (void)authorizeUsingWebView:(UIWebView *)webView additionalParameters:(NSDictionary *)additionalParameters;
{
    
    NSLog(@"%@",[self getAccessCodeRequest]);
    [webView loadRequest:[self getAccessCodeRequest]]; //Requesting access code request.
    NSLog(@"Requesting for Access token");
    
    
    

}

#pragma mark WebView Delegate Methods


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    
    NSLog(@"WebView Delegate: shouldStartLoadWithRequest....");
    

    NSLog(@"%@,%@",[self.redirectURL absoluteString],request.URL);
  if ([[request.URL absoluteString] hasPrefix:[self.redirectURL absoluteString]]) {

      
      NSLog(@"Web view request URL has redirect URL prefix...");
      [self extractAccessCodeFromCallbackURL:request.URL];
      return NO;
      
  } else if (self.cancelURL && [[request.URL absoluteString] hasPrefix:[self.cancelURL absoluteString]]) {
    if ([self.delegate respondsToSelector:@selector(oauthClientDidCancel:)]) {
      [self.delegate oauthClientDidCancel:self];
    }
    
    return NO;
  }
  
  if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
      //FIX ME check this implementation..
    return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }
  
    
    
  return YES;
}

/**
 * custom URL schemes will typically cause a failure so we should handle those here
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"WebView Delegate: didFailLoadWithError....%@",[error description]);

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_3_2
  NSString *failingURLString = [error.userInfo objectForKey:NSErrorFailingURLStringKey];
#else
  NSString *failingURLString = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
#endif
  
  if ([failingURLString hasPrefix:[self.redirectURL absoluteString]]) {
    [webView stopLoading];
    [self extractAccessCodeFromCallbackURL:[NSURL URLWithString:failingURLString]];
  } else if (self.cancelURL && [failingURLString hasPrefix:[self.cancelURL absoluteString]]) {
    [webView stopLoading];
    if ([self.delegate respondsToSelector:@selector(oauthClientDidCancel:)]) {
      [self.delegate oauthClientDidCancel:self];
    }
  }
  
  if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
    [self.delegate webView:webView didFailLoadWithError:error];
  }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog(@"WebView Delegate: webViewDidStartLoad....");

  if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
    [self.delegate webViewDidStartLoad:webView];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSLog(@"WebView Delegate: webViewDidFinishLoad....");

  if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [self.delegate webViewDidFinishLoad:webView];
  }
}

#pragma mark Extract Access code

- (void)extractAccessCodeFromCallbackURL:(NSURL *)callbackURL;
{
    NSLog(@"Extracting access code from Call back URL");
    NSLog(@"Call back URL with Access code: %@",callbackURL);
    
  NSString *accessCode = [[callbackURL queryDictionary] valueForKey:@"code"];
    
    if (accessCode) {
        NSLog(@"Access code value is not nil...");
        NSLog(@"Reveived access code:%@",accessCode);
        
        //FIX ME : Move to a different method.
        [self verifyAuthorizationWithAccessCode:accessCode];
        
        if ([self.delegate respondsToSelector:@selector(oauthClientDidReceiveAccessCode:)]) {
            [self.delegate oauthClientDidReceiveAccessCode:self];
        }

    }
    else{
        //FIX ME throw exceptions
        NSLog(@"Access code value is nil...");
    }
    
}

@end
