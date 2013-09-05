//
//  SkyDriveConnector.h
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 05/09/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

@interface SkyDriveConnector : NSObject

typedef enum {
	SKYDRIVE_USER_ABOUT = 1001,
	SKYDRIVE_USER_CHANGES,
	SKYDRIVE_USER_APPS,
    
}SKYDRIVE_USER_API;


- (id)initWithAuthorizingWebView:(UIWebView*)webView;

- (NSURL*)getDataForSkyDriveAPI:(SKYDRIVE_USER_API)api;

@end
