//
//  InstagramConnector.h
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 15/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
	INSTAGRAM_USER_ABOUT = 1001,
	INSTAGRAM_USER_FRIENDS,
	INSTAGRAM_USER_PHOTOS,
    
}INSTAGRAM_USER_API;


@interface InstagramConnector : NSObject


- (id)initWithAuthorizingWebView:(UIWebView*)webView;

- (NSURL*)getDataForinstagramAPI:(INSTAGRAM_USER_API)api;


@end
