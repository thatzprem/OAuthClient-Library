//
//  SocialConnectViewController.m
//  SociallyConnecting
//
//  Created by myCompany on 18/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "SocialConnectViewController.h"
#import "OAuthRequiredParameter.h"
#import "OAuthManager.h"
#import "FlickrConnector.h"
#import "TwitterConnector.h"

@interface SocialConnectViewController ()
{
    FlickrConnector *manager;
    TwitterConnector *twitterManager;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SocialConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*
     Flicker
     SocialConnector
     
     Key:
     4baea9e751b7bf404e5831525ad36e53
     
     Secret:
     478068baf865989f
     */
    

    
    manager = [[FlickrConnector alloc]initWithConsumerKey:@"4baea9e751b7bf404e5831525ad36e53" secret:@"478068baf865989f"webViewToAuthorize:self.webView confirmation:^(BOOL confirm) {
        
        if(confirm)
        {
            [self getProfile];
        }
        
    }];
    
//    twitterManager = [[TwitterManager alloc]initWithConsumerKey:@"HBJVaYTlusXHM4zrLrt6EQ" secret:@"h6y3TIBbZanFa5ChW8047w54fmTHsmLK8LpriypEiw" webViewToAuthorize:self.webView confirmation:^(BOOL confirm) {
//        
//        
//        if(confirm)
//        {
//            [self getProfile];
//        }
//    }];
    
    
}

-(void) getProfile
{
//    [twitterManager getUserProfile:^(NSString *details) {
//        NSLog(@"detail  User profile %@",details);
//    }];
//    
//    [twitterManager getUserFollowerList:^(NSString *confirm) {
//        
//        NSLog(@"detail  User Follower %@",confirm);
//    }];
//    
//    [twitterManager getUserTimeLineList:^(NSString *confirm) {
//        NSLog(@"detail Time Line %@",confirm);
//    }];
    
    [manager getUserProfile:^(NSString *details) {
        
        NSLog(@" User Profile detail %@",details);
    }];
    
    [manager getUseFriendList:^(NSString *details) {
        
        NSLog(@" User Friend detail %@",details);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
