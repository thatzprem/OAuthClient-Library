//
//    AppDelegate.h
//    OAuth2ClientApplication
//
//  Created by Prem kumar on 18/04/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTableViewController;@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HomeTableViewController *viewController;
@property (nonatomic) int service;


@end
