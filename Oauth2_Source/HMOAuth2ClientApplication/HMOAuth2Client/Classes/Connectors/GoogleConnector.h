//
//  GoogleConnector.h
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 17/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GoogleConnector : NSObject

typedef enum {
	GOOGLE_USER_ABOUT = 1001,
	GOOGLE_USER_FRIENDS,
	GOOGLE_USER_MOMENTS,
    
}GOOGLE_USER_API;


- (id)initWithAuthorizingWebView:(UIWebView*)webView;

- (NSURL*)getDataForGoogleAPI:(GOOGLE_USER_API)api;

@end
