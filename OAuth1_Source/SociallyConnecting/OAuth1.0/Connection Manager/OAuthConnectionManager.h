//
//  OAuthConnectionManager.h
//  SociallyConnecting
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^connectionCompletionBlock)(id  details);

@interface OAuthConnectionManager : NSObject <NSURLConnectionDelegate>

-(id)initWithRequest:(NSURLRequest *) request WithComplition:(connectionCompletionBlock)completionHandler;

@end
