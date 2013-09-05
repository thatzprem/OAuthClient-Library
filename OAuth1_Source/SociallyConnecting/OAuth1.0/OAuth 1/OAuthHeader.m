//
//  OAuthHeader.m
//  SociallyConnecting
//
//  Created by myCompany on 23/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "OAuthHeader.h"
#import "NSString+URLEncoding.h"
#import "OAuthSignature.h"
#import "OAuthConsumer.h"
#import "OAuthAccessToken.h"
#import "NSMutableURLRequest+Parameters.h"
#import "OARequestParameter.h"

@interface OAuthHeader ()
{
    NSString *timestamp;
    NSString *nonce;
}

@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,strong) OAuthSignature * signatureProvider;
@property (nonatomic,strong) NSString *signature;

@end

@implementation OAuthHeader

-(id)init
{
    self = [super init];
    
    if(self)
    {
        
         self.signatureProvider  =[[OAuthSignature alloc]init];
        
    }
    return self;
}

-(void) getHeaderForRequest:(NSMutableURLRequest *)request
{
    
    self.request = request;
    [request addValue:[self createOAuthHeader:request] forHTTPHeaderField:@"Authorization"];
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
    
    
    if([self.callBackURl length]>0)
    {
       [chunks addObject:[NSString stringWithFormat:@"oauth_callback=\"%@\"", [self.callBackURl encodedURLParameterString]]]; 
    }
    
    
    if(self.accessToken)
    {
        
        
        
        NSDictionary *tokenParameters = [self.accessToken parameters];
        for (NSString *k in tokenParameters)
        {
            [chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[tokenParameters objectForKey:k] encodedURLParameterString]]];
        }
    }
    
    
    NSString *tokenSecret = self.accessToken.secret ? self.accessToken.secret : @"";
    NSString *tokenSecretAndConsumerSecret = [NSString stringWithFormat:@"%@&%@",
                                              self.consumer.secret,
                                              tokenSecret];
    NSString *baseStringForSig = [self baseString:request];
    self.signature = [self.signatureProvider  hashedValue:baseStringForSig andMessage:tokenSecretAndConsumerSecret];
    
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [self.signature encodedURLParameterString]]];
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    
    
    NSLog(@"Oauth header %@",oauthHeader);
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
    [parameterPairs addObject:[self URLEncodedName:@"oauth_consumer_key" Value:self.consumer.identifier]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_signature_method" Value:[self.signatureProvider name]]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_timestamp" Value:timestamp]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_nonce" Value:nonce]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_version" Value:@"1.0"]];
    
    
    
    
   
        if ([self.callBackURl length] > 0)
        {
            [parameterPairs addObject:[self URLEncodedName:@"oauth_callback" Value:self.callBackURl]];
        }

    
    if (self.accessToken) {
        
        NSDictionary *tokenParameters = [self.accessToken parameters];
        
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
    NSURL *url = self.request.URL;
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
  //  NSArray *secondPartpair = [[parts objectAtIndex:1] componentsSeparatedByString:@"&"];
    
    NSLog(@"Request Tpe %@",[self.request HTTPMethod]);
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    
    
    return [NSString stringWithFormat:@"%@&%@&%@",
            [self.request HTTPMethod],
            [urlSTring encodedURLParameterString],
            [normalizedRequestParameters encodedURLString]];
	
}

- (NSString *)URLEncodedName:(NSString *)name Value:(NSString *)value {
    return [NSString stringWithFormat:@"%@=%@",name, [value encodedURLParameterString]];
}

@end
