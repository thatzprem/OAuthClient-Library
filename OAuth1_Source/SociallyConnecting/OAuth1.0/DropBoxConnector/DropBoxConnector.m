//
//  DropBoxConnector.m
//  SociallyConnecting
//
//  Created by Prem kumar on 31/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "DropBoxConnector.h"
#import "OAuthConsumer.h"
#import "OAuthAccessToken.h"
#import "OAuthManager.h"
#import "OAuthRequiredParameter.h"
#import "OAuthHeader.h"
#import "OAuthConnectionManager.h"

@interface DropBoxConnector ()

@property (nonatomic,strong) OAuthAccessToken *accessToken;
@property (nonatomic,strong) OAuthConsumer *consumer;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) OAuthHeader *header;
@property (nonatomic,strong) NSString *userId;

@end


@implementation DropBoxConnector
-(id) initWithConsumerKey:(NSString *)key  secret:(NSString *)secret webViewToAuthorize:(UIWebView *)webView confirmation:(void (^)(BOOL))handler
{
    self = [super init];
    
    if(self)
    {
        self.consumer = [[OAuthConsumer alloc]initWithConsumerIdentifier:key withSecretKey:secret withRealm:@""];
        self.webView = webView;
        self.header = [[OAuthHeader alloc]init];
        [self getOAuthAccessTokenconfirmation:handler];
        
    }
    return self;
}


-(void) getOAuthAccessTokenconfirmation:(void (^)(BOOL))handler
{
    
    OAuthRequiredParameter *parameter = [[OAuthRequiredParameter alloc]init];
    
    [parameter setConsumerKey:self.consumer.identifier];
    [parameter setSecreatKey:self.consumer.secret];
    [parameter setWebView:self.webView];
    [parameter setRequestTokenURL:@"https://api.dropbox.com/1/oauth/request_token"];
    [parameter setAuthorizationURL:@"https://www.dropbox.com/1/oauth/authorize"];
    [parameter setAccessTokenURL:@"https://api.dropbox.com/1/oauth/access_token"];
    [parameter setCallBackURL:@"http://www.thatzprem.wordpress.com"];
    
    [OAuthManager authoriseTheClientWithRequiredParameters:parameter withCompletionoAuthDetails:^(id details) {
        
        NSLog(@"Details = %@",details);
        
        
        if(details)
        {
            NSString *string = details;
            
            NSLog(@"%@",string);
            
            NSArray *pairs = [string componentsSeparatedByString:@"&"];
            
            for (NSString *pair in pairs)
            {
                NSArray *elements = [pair componentsSeparatedByString:@"="];
                
                if ([[elements objectAtIndex:0] isEqualToString:@"xoauth_yahoo_guid"])
                {
                    self.userId =[elements objectAtIndex:1];
                }
            }
            
            self.accessToken = [[OAuthAccessToken alloc]initWithHTTPResponseBody:string];
            
            handler(YES);
            
        }
        else
        {
            handler(NO);
        }
        
    }];
}


-(void) getUserProfile:(void(^)(NSString * details))handler
{
    
    NSString *profileUrl = [NSString stringWithFormat:@"http://social.yahooapis.com/v1/user/%@/profile?format=json",self.userId];
    
    //    NSString *profileUrl = [NSString stringWithFormat:@"http://social.yahooapis.com/v1/me/guid"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:profileUrl]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"1.0" forHTTPHeaderField:@"version"];
    
    [request setHTTPMethod:@"GET"];
    
    [self.header setAccessToken:self.accessToken];
    [self.header setConsumer:self.consumer];
    [self.header getHeaderForRequest:request];
    
    NSLog(@"%@",request);
    NSLog(@"%@",self.accessToken);
    NSLog(@"%@",self.consumer);
    NSLog(@"%@",self.consumer.identifier);
    NSLog(@"%@",self.userId);
    
    
    
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSLog(@"details %@",details);
        handler(details);
    }];
    
    NSLog(@"Connection %@",connection);
}

-(void) getUseFriendList:(void(^)(NSString * details))handler
{
    
    NSString *profileUrl = [NSString stringWithFormat:@"http://social.yahooapis.com/v1/user/%@/contacts?format=json",self.userId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:profileUrl]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    [self.header setAccessToken:self.accessToken];
    [self.header setConsumer:self.consumer];
    [self.header getHeaderForRequest:request];
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSLog(@"details %@",details);
        handler(details);
    }];
    
    NSLog(@"Connection %@",connection);
}@end
