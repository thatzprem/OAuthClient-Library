//
//  FlickrManager.m
//  SociallyConnecting
//
//  Created by myCompany on 23/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "FlickrConnector.h"
#import "OAuthConsumer.h"
#import "OAuthAccessToken.h"
#import "OAuthManager.h"
#import "OAuthRequiredParameter.h"
#import "OAuthHeader.h"
#import "OAuthConnectionManager.h"

@interface FlickrConnector ()

@property (nonatomic,strong) OAuthAccessToken *accessToken;
@property (nonatomic,strong) OAuthConsumer *consumer;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) OAuthHeader *header;
@property (nonatomic,strong) NSString *userId;

@end

@implementation FlickrConnector

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
    [parameter setRequestTokenURL:@"http://www.flickr.com/services/oauth/request_token"];
    [parameter setAuthorizationURL:@"http://www.flickr.com/services/oauth/authorize"];
    [parameter setAccessTokenURL:@"http://www.flickr.com/services/oauth/access_token"];
    [parameter setCallBackURL:@"http://www.example.com"];
    
    [OAuthManager authoriseTheClientWithRequiredParameters:parameter withCompletionoAuthDetails:^(id details) {
        
        if(details)
        {
            NSString *string = details;
            
            NSArray *pairs = [string componentsSeparatedByString:@"&"];
            
            for (NSString *pair in pairs)
            {
                NSArray *elements = [pair componentsSeparatedByString:@"="];
                
                if ([[elements objectAtIndex:0] isEqualToString:@"user_nsid"])
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
    
    NSString *profileUrl = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.urls.getUserProfile&api_key=%@&user_id=%@&per_page=10&format=json&nojsoncallback=1", self.consumer.identifier,self.userId];
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
}

-(void) getUseFriendList:(void(^)(NSString * details))handler
{
    
    NSString *profileUrl = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.contacts.getList&api_key=%@&user_id=%@&per_page=10&format=json&nojsoncallback=1", self.consumer.identifier,self.userId];
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
}



@end
