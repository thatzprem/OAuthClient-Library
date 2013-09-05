//
//  YahooConnector.h
//  SociallyConnecting
//
//  Created by Prem kumar on 25/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooConnector : NSObject



-(id) initWithConsumerKey:(NSString *)key  secret:(NSString *)secret webViewToAuthorize:(UIWebView *)webView confirmation:(void(^)(BOOL confirm))handler;


-(void) getUserProfile:(void(^)(NSString * details))handler;

-(void) getUseFriendList:(void(^)(NSString * details))handler;

@end
