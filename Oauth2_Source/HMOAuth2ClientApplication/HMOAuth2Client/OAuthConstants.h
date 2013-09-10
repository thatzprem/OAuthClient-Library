//
//  HMOAuthConstants.h
//  HMOAuth2ClientApplication
//
//  Created by Prem kumar on 28/04/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#ifndef OAuth2ClientApplication_OAuthConstants_h
#define OAuth2ClientApplication_OAuthConstants_h

#import "NSDate+NSDateUtility.h"

/**
 General OAuth-Component configurations.
 */

#define OAUTH2_CONFIG_FILENAME  @"HMOAuth2ClientConfig"

#define OAUTH2_CONFIG_FILE_EXTENSION  @"plist"

#define ACCESS_TOKEN_SUCCESS_RESPONSE_STATUSCODE 200


//Logging methods.
#define start_time()  NSLog(@"%@: %@ Start time: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd),[NSDate date]);

#define inputParameters(format, ...)  NSLog(@"%@ %@",[NSString stringWithFormat:@"%@: %@ Input Parameters: ",currentClassName,currentMethodName],[NSString stringWithFormat:format, ##__VA_ARGS__]);

#define returnValues(format, ...)  NSLog(@"%@: %@",[NSString stringWithFormat:@"%@ %@ Return Parameters: ",currentClassName,currentMethodName],[NSString stringWithFormat:format, ##__VA_ARGS__])

//#define totalTimeOfExecution(startDate,endDate)  NSLog(@"%@: %@ Execution time: %@",currentClassName,currentMethodName,[startDate calculateTimeDifferentinHourMinute:endDate])

#define totalTimeOfExecution(startDate,endDate)  NSLog(@"%@ TotalTime taken to execute %@ is %@",currentClassName,currentMethodName,[startDate calculateTimeDifferentinHourMinute:endDate])


#define end_time()  NSLog(@"%@: %@ End time: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd),[NSDate date]);

//Other logging utils
#define currentClassName NSStringFromClass([self class])
#define currentMethodName NSStringFromSelector(_cmd)
#define currentDate [NSDate date]
#define currentClassAndMethodName() NSLog(@"Class :%@ Method: %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd))

#endif
