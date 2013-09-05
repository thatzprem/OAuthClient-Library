//
//  TwitterManager.m
//  SociallyConnecting
//
//  Created by myCompany on 23/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "TwitterConnector.h"
#import "OAuthConsumer.h"
#import "OAuthAccessToken.h"
#import "OAuthManager.h"
#import "OAuthRequiredParameter.h"
#import "OAuthHeader.h"
#import "OAuthConnectionManager.h"

@interface TwitterConnector ()


@property (nonatomic,strong) OAuthAccessToken *accessToken;
@property (nonatomic,strong) OAuthConsumer *consumer;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) OAuthHeader *header;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *screenName;
@end

@implementation TwitterConnector

-(id) initWithConsumerKey:(NSString *)key  secret:(NSString *)secret webViewToAuthorize:(UIWebView *)webView confirmation:(void (^)(BOOL))handler
{
    self = [super init];
    
    if(self)
    {
        self.consumer = [[OAuthConsumer alloc]initWithConsumerIdentifier:key withSecretKey:secret withRealm:@"https://api.twitter.com"];
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
    [parameter setRequestTokenURL:@"https://api.twitter.com/oauth/request_token"];
    [parameter setAuthorizationURL:@"https://api.twitter.com/oauth/authorize"];
    [parameter setAccessTokenURL:@"https://api.twitter.com/oauth/access_token"];
    [parameter setCallBackURL:@"https://twitter.com/"];
    
    [OAuthManager authoriseTheClientWithRequiredParameters:parameter withCompletionoAuthDetails:^(id details) {
        
        if(details)
        {
            NSString *string = details;
            
            
            NSArray *pairs = [string componentsSeparatedByString:@"&"];
            
            for (NSString *pair in pairs)
            {
                NSArray *elements = [pair componentsSeparatedByString:@"="];
                
                if ([[elements objectAtIndex:0] isEqualToString:@"user_id"])
                {
                    self.userId =[elements objectAtIndex:1];
                }
                else if ([[elements objectAtIndex:0] isEqualToString:@"screen_name"])
                {
                    self.screenName =[elements objectAtIndex:1];
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

-(void)getUserProfile:(void(^)(NSString *confirm))handler
{
    NSString *profileUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=2",self.screenName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:profileUrl]];
    
    NSLog(@"Request Abosulte usr %@ string %@",request.URL.absoluteURL , request.URL.absoluteString);
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [self.header setAccessToken:self.accessToken];
    [self.header setConsumer:self.consumer];
    [self.header getHeaderForRequest:request];
    
      NSLog(@"User Profiel %@",[request allHTTPHeaderFields]);
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSLog(@"details %@",details);
        
        
        handler(details);
    }];
    
    NSLog(@"Connection %@",connection);
}

-(void)getUserFollowerList:(void(^)(NSString *confirm))handler
{
    NSString *profileUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/ids.json?cursor=-1&screen_name=%@&count=5",self.screenName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:profileUrl]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [self.header setAccessToken:self.accessToken];
    [self.header setConsumer:self.consumer];
    [self.header getHeaderForRequest:request];
    
     NSLog(@"Follower Request %@",request);
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSLog(@"details %@",details);
        
        
        handler(details);
    }];
    
    NSLog(@"Connection %@",connection);

}

-(void)getUserTimeLineList:(void(^)(NSString *confirm))handler
{
    NSString *profileUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=2",self.screenName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:profileUrl]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [self.header setAccessToken:self.accessToken];
    [self.header setConsumer:self.consumer];
    [self.header getHeaderForRequest:request];
    
     NSLog(@"TimeLine Request %@",request);
    
    OAuthConnectionManager *connection = [[OAuthConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSLog(@"details TimeLine %@",details);
        
        
        handler(details);
    }];
    
    NSLog(@"Connection %@",connection);
}

@end
