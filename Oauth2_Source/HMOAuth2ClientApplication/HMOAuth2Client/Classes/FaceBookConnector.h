//
//  SocialConnectorFaceBookHandler.h
//  SocialConnector
//
//  Created by Testing on 25/04/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	FACEBOOK_USER_ABOUT = 1001,
	FACEBOOK_USER_FRIENDS,
	FACEBOOK_USER_PHOTOS,
}FACEBOOK_USER_API;

@interface FaceBookConnector : NSObject

- (id)initWithAuthorizingWebView:(UIWebView*)webView;

- (NSURL*)getDataForFaceBookAPI:(FACEBOOK_USER_API)api;


@end
