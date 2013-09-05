//
//  OAuthRequiredParameter.h
//  SociallyConnecting
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthRequiredParameter : NSObject

@property (nonatomic,strong) NSString *requestTokenURL;
@property (nonatomic,strong) NSString *authorizationURL;
@property (nonatomic,strong) NSString *callBackURL;
@property (nonatomic,strong) NSString *accessTokenURL;
@property (nonatomic,strong) NSString *consumerKey;
@property (nonatomic,strong) NSString *secreatKey;
@property (nonatomic,strong) UIWebView *webView;


@end
