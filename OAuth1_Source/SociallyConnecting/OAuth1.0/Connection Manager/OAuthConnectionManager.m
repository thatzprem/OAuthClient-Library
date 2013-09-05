//
//  OAuthConnectionManager.m
//  SociallyConnecting
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "OAuthConnectionManager.h"

@interface OAuthConnectionManager ()

@property (nonatomic,strong) connectionCompletionBlock callBack;
@property (nonatomic,strong) NSMutableData *recievedData;
@property (nonatomic,assign) BOOL success;

@end

@implementation OAuthConnectionManager

-(id)initWithRequest:(NSURLRequest *) request WithComplition:(connectionCompletionBlock)completionHandler
{
    self = [super init];
    
    if(self)
    {
        
        self.callBack =completionHandler;
        
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
    }
    
    
    return self;
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error %@",error);
    self.callBack (nil);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.recievedData = [NSMutableData dataWithData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    
    
    NSString *stringData= [[NSString alloc]
                           initWithData:self.recievedData encoding:NSUTF8StringEncoding];
    
    self.callBack (stringData);
}


- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse {
    int status  = [(NSHTTPURLResponse * )aResponse statusCode];
    
    if(status <400)
    {
        self.success = YES;
    }
    
}
@end
