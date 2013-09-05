//
//  GoogleConnector.h
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 17/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GoogleDriveConnector : NSObject

typedef enum {
	GOOGLE_DRIVE_USER_ABOUT = 1001,
	GOOGLE_DRIVE_USER_CHANGES,
	GOOGLE_DRIVE_USER_APPS,
    
}GOOGLE_DRIVE_USER_API;


- (id)initWithAuthorizingWebView:(UIWebView*)webView;

- (NSURL*)getDataForGoogleDriveAPI:(GOOGLE_DRIVE_USER_API)api;

@end
