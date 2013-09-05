//
//  OAuth1_0.m
//  OAuth1.0
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "OAuthManager.h"
#import "NSString+URLEncoding.h"
#import "OAuthSignature.h"
#import "OAuthConsumer.h"
#import "OAuthAccessToken.h"
#import "NSMutableURLRequest+Parameters.h"
#import "OARequestParameter.h"
#import "WebAuthorization.h"
#import "OAuthConnectionManager.h"

@interface OAuthManager () <NSURLConnectionDelegate,webAuthorizedDelegate>
{
    NSString *nonce;
    NSString *timestamp;
}
-(id) initWithParameters:(OAuthRequiredParameter *)iParameters complietionBlock:(oAuthCompletionBlock)block;


@property (nonatomic,strong) OAuthRequiredParameter *OAuthparameters;
@property (nonatomic,strong) OAuthConsumer *consumer;
@property (nonatomic,strong) OAuthAccessToken *token;
@property (nonatomic,strong) OAuthSignature * signatureProvider;
@property (nonatomic,strong) NSString *callBackURl;
@property (nonatomic,strong) OAuthAccessToken *requestToken;
@property (nonatomic,strong) UIWebView *managerWebView;
@property (nonatomic,strong) WebAuthorization *authorizeObject;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,copy) oAuthCompletionBlock completionBlock;
@property (nonatomic,strong) NSString *signature;


@end

@implementation OAuthManager

+(void) authoriseTheClientWithRequiredParameters:(OAuthRequiredParameter *)parameters
                      withCompletionoAuthDetails:(oAuthCompletionBlock)completionHandler
{
     OAuthManager *manager = [[OAuthManager alloc]initWithParameters:parameters complietionBlock:completionHandler];
    NSLog(@" OUtha %@",manager);
}

-(id) initWithParameters:(OAuthRequiredParameter *)iParameters complietionBlock:(oAuthCompletionBlock)block{
    
    self =[super init];
    
    if(self)
    {
       self.OAuthparameters = iParameters;
        self.completionBlock = block;
        
        self.consumer = [[OAuthConsumer alloc]initWithConsumerIdentifier:iParameters.consumerKey withSecretKey:iParameters.secreatKey withRealm:@""];
        self.token = [[OAuthAccessToken alloc]init];
        self.signatureProvider  =[[OAuthSignature alloc]init];
        self.callBackURl = iParameters.callBackURL;
       
        [self getRequestToken];
    }
    return self;
}

-(void) getRequestToken
{
    
    self.status = REQUEST_TOKEN;
    
    NSURL *url = [NSURL URLWithString:self.OAuthparameters.requestTokenURL];
    
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlSTring]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [request addValue:[self createOAuthHeader:request] forHTTPHeaderField:@"Authorization"];
    
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSString *stringData = details;
        
        if(!self.requestToken)
        {
            self.requestToken = [[OAuthAccessToken alloc]initWithHTTPResponseBody:stringData];
        }
        
        if(self.requestToken)
        {
            [self loadWebViewForAuthorization];
        }
        else{
            self.completionBlock (nil);
        }
        
    }];
    
    NSLog(@"Connection %@",connection);
    

}

-(NSString *) createOAuthHeader:(NSMutableURLRequest *)request
{
    
    [self _generateNonce];
    [self _generateTimestamp];
    
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    [chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [self.consumer.identifier encodedURLParameterString]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", nonce]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[self.signatureProvider name] encodedURLParameterString]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", timestamp]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
    
    
    if([self.status isEqualToString:REQUEST_TOKEN])
    {
       [chunks addObject:[NSString stringWithFormat:@"oauth_callback=\"%@\"", [self.callBackURl encodedURLParameterString]]]; 
    }
    
    if(self.requestToken)
    {
        
        
        
        NSDictionary *tokenParameters = [self.requestToken parameters];
        for (NSString *k in tokenParameters)
        {
            [chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[tokenParameters objectForKey:k] encodedURLParameterString]]];
        }
    }
   

    NSString *tokenSecret = self.requestToken.secret ? self.requestToken.secret : @"";
    NSString *tokenSecretAndConsumerSecret = [NSString stringWithFormat:@"%@&%@",
                                              self.consumer.secret,
                                              tokenSecret];
    NSString *baseStringForSig = [self baseString:request];
    self.signature = [self.signatureProvider  hashedValue:baseStringForSig andMessage:tokenSecretAndConsumerSecret];
    
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [self.signature encodedURLParameterString]]];
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    
    return oauthHeader;
}

- (void)_generateTimestamp
{
    timestamp = [[NSString alloc]initWithFormat:@"%ld", time(NULL)];
}

- (void)_generateNonce
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	if (nonce) {
		CFRelease((__bridge CFTypeRef)(nonce));
	}
    nonce = (__bridge NSString *)string;
    
}


-(NSString *)baseString:(NSMutableURLRequest *)request
{
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] init];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_consumer_key" Value:self.OAuthparameters.consumerKey]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_signature_method" Value:[self.signatureProvider name]]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_timestamp" Value:timestamp]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_nonce" Value:nonce]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_version" Value:@"1.0"]];
    
   
    
    
    if([self.status isEqualToString:REQUEST_TOKEN])
    {
        if ([self.callBackURl length] > 0)
        {
            [parameterPairs addObject:[self URLEncodedName:@"oauth_callback" Value:self.callBackURl]];
        }
    }
   
    if (self.requestToken) {
        
        NSDictionary *tokenParameters = [self.requestToken parameters];
        
        for(NSString *k in tokenParameters) {
            [parameterPairs addObject:[[OARequestParameter requestParameter:k value:[tokenParameters objectForKey:k]] URLEncodedNameValuePair]];
        }
        
    }
    
    if(request)
    {
        
        NSArray *parameters  =[request parameters];
        if (![[request valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"]) {
            for (OARequestParameter *param in parameters) {
                [parameterPairs addObject:[param URLEncodedNameValuePair]];
            }
        }
    }
    
    
	
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    NSURL *url =nil;
    
    url = [request URL];
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    

    return [NSString stringWithFormat:@"%@&%@&%@",
            [request HTTPMethod],
            [urlSTring encodedURLParameterString],
            [normalizedRequestParameters encodedURLString]];
	
}

- (NSString *)URLEncodedName:(NSString *)name Value:(NSString *)value {
    return [NSString stringWithFormat:@"%@=%@",name, [value encodedURLParameterString]];
}








-(void) loadWebViewForAuthorization
{
    
    self.status = AUTHORIZATION;
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@",
                                       self.OAuthparameters.authorizationURL,self.requestToken.key];
    
    NSURL  *userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    
    self.managerWebView = self.OAuthparameters.webView;
    [self.managerWebView setHidden:NO];
    
    self.authorizeObject = [[WebAuthorization alloc]init];
    self.authorizeObject.requestToken = self.requestToken;
    self.authorizeObject.authorizedUrl =self.OAuthparameters.callBackURL;
    self.authorizeObject.delegate = self;
    [self.managerWebView setDelegate:self.authorizeObject];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:userLoginURL];
    [self.managerWebView loadRequest:request];
}


-(void)loadedSuccesfully:(OAuthAccessToken *)requestToken
{
    
    if(requestToken)
    {
        self.managerWebView.hidden = YES;
        //    self.authorizeObject.delegate = nil;
        //    self.authorizeObject = nil;
        
        [self getAccessToken];
    }
    else{
        
        self.completionBlock (nil);
    }
 
    
}

-(void) getAccessToken
{
    
    self.status = ACCESS_TOKEN;
    
    NSURL *url = [NSURL URLWithString:self.OAuthparameters.accessTokenURL];
    
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlSTring]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    [request addValue:[self createOAuthHeader:request] forHTTPHeaderField:@"Authorization"];
    
    
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        if(details)
        {
            NSString *stringData = details;
            
            self.token = [[OAuthAccessToken alloc]initWithHTTPResponseBody:stringData];
            
            self.completionBlock (stringData);
        }
        else
        {
            self.completionBlock (nil);
        }
        
    }];
    
    NSLog(@"Connection %@",connection);
}
@end
