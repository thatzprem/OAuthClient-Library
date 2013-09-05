//
//  OAuth1_0.h
//  OAuth1.0
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthRequiredParameter.h"

@interface OAuthManager : NSObject

typedef void (^oAuthCompletionBlock)(id details);

+(void) authoriseTheClientWithRequiredParameters:(OAuthRequiredParameter *)parameters
                    withCompletionoAuthDetails:(oAuthCompletionBlock)completionHandler;
@end
