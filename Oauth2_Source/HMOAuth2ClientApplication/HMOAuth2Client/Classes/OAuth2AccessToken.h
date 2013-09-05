//
//  OAuth2AccessToken.h
//  OAuth2Client
//
/**
 Created by Prem on 12/03/13.
 Copyright (c) 2013 NexTip Solutions
 This program is not to be copied or distributed without the express written consent of NexTip. All rights reserved.
 */

#import <UIKit/UIKit.h>


@interface OAuth2AccessToken : UIView <NSCoding> {
  NSDictionary *authResponseData;
  NSDate *expiresAt;
}
@property (unsafe_unretained, nonatomic, readonly) NSString *accessToken;
@property (unsafe_unretained, nonatomic, readonly) NSString *refreshToken;
@property (nonatomic, readonly) NSDate *expiresAt;

- (id)initWithAuthorizationResponse:(NSDictionary *)_data;
- (void)refreshFromAuthorizationResponse:(NSDictionary *)data;
- (BOOL)hasExpired;
@end
