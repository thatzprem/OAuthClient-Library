//
//  GoogleConnector.h
//  OAuth2ClientApplication
//
//  Created by Prem kumar on 17/05/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PicasaConnector : NSObject

typedef enum {
	PICASA_USER_ABOUT = 1001,
	PICASA_USER_CHANGES,
	PICASA_USER_APPS,
    
}PICASA_USER_API;


- (id)initWithAuthorizingWebView:(UIWebView*)webView;

- (NSURL*)getDataForPicasaAPI:(PICASA_USER_API)api;

@end
