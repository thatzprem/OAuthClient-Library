//
//  TwitterManager.h
//  SociallyConnecting
//
//  Created by myCompany on 23/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterConnector : NSObject

-(id) initWithConsumerKey:(NSString *)key
                   secret:(NSString *)secret
       webViewToAuthorize:(UIWebView *)webView
             confirmation:(void(^)(BOOL confirm))handler;

-(void)getUserProfile:(void(^)(NSString *confirm))handler;

-(void)getUserFollowerList:(void(^)(NSString *confirm))handler;

-(void)getUserTimeLineList:(void(^)(NSString *confirm))handler;

@end
