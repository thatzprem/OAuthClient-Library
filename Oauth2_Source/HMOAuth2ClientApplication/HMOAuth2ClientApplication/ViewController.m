//
//  HMViewController.m
//  HMOAuth2ClientApplication
//
//  Created by Prem kumar on 18/04/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import "ViewController.h"
#import "OAuth2Client.h"
#import "LROAuth2ClientDelegate.h"
#import "InstagramConnector.h"
#import "FaceBookConnector.h"
#import "GoogleConnector.h"
#import "AppDelegate.h"
#import "GoogleDriveConnector.h"
#import "PicasaConnector.h"
#import "SkyDriveConnector.h"

@interface ViewController ()<OAuth2ClientDelegate>{

    FaceBookConnector *faceBookConnector;
    InstagramConnector *instagramConnector;
    GoogleConnector *googleConnector;
    GoogleDriveConnector *googleDriveConnector;
    PicasaConnector *picasaConnector;
    SkyDriveConnector *skyDriveConnector;
    UIAlertView* alertView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    AppDelegate *delegate =  [[UIApplication sharedApplication] delegate];
    

    if (delegate.service == 0){
           faceBookConnector = [[FaceBookConnector alloc] initWithAuthorizingWebView:self.webView];

    }
    else if (delegate.service == 1){
            instagramConnector = [[InstagramConnector alloc] initWithAuthorizingWebView:self.webView];
   
    }
    else if (delegate.service == 2){
            googleConnector = [[GoogleConnector alloc] initWithAuthorizingWebView:self.webView];
    }
    else if (delegate.service == 3){
            
        googleDriveConnector = [[GoogleDriveConnector alloc]initWithAuthorizingWebView:self.webView];
    }
    else if (delegate.service == 4){
        
        picasaConnector = [[PicasaConnector alloc]initWithAuthorizingWebView:self.webView];
    }
    else if (delegate.service == 5){
        
        skyDriveConnector = [[SkyDriveConnector alloc]initWithAuthorizingWebView:self.webView];
    }
    else{
        
    }
}

- (void)receiveTestNotification:(NSNotification *) notification{

    self.webView.hidden = YES;
    
}

-(IBAction)refresh:(id)sender{
    
    
    NSURL* receivedURL = [[NSURL alloc] init];

    AppDelegate *delegate =  [[UIApplication sharedApplication] delegate];
    
    UIButton *senderButton = sender;
    
    if (delegate.service == 0){
        if (senderButton.tag == 100) {
                receivedURL = [faceBookConnector getDataForFaceBookAPI:FACEBOOK_USER_ABOUT];
        }
        else if (senderButton.tag ==101){
                receivedURL = [faceBookConnector getDataForFaceBookAPI:FACEBOOK_USER_FRIENDS];
        }
        else if (senderButton.tag ==102){
                receivedURL = [faceBookConnector getDataForFaceBookAPI:FACEBOOK_USER_PHOTOS];
        }
        
    }
    else if (delegate.service == 1){
        
        if (senderButton.tag == 100) {
                receivedURL = [instagramConnector getDataForinstagramAPI:INSTAGRAM_USER_ABOUT];
        }
        else if (senderButton.tag ==101){
                receivedURL = [instagramConnector getDataForinstagramAPI:INSTAGRAM_USER_FRIENDS];
        }
        else if (senderButton.tag ==102){
                receivedURL = [instagramConnector getDataForinstagramAPI:INSTAGRAM_USER_PHOTOS];
        }
        
    }
    else if (delegate.service == 2){
        
        if (senderButton.tag == 100) {
            receivedURL = [googleConnector getDataForGoogleAPI:GOOGLE_USER_ABOUT];
        }
        else if (senderButton.tag ==101){
            receivedURL = [googleConnector getDataForGoogleAPI:GOOGLE_USER_FRIENDS];
        }
        else if (senderButton.tag ==102){
            receivedURL = [googleConnector getDataForGoogleAPI:GOOGLE_USER_MOMENTS];
        }
    }
    else if (delegate.service == 3){
        
        if (senderButton.tag == 100) {
            receivedURL = [googleDriveConnector getDataForGoogleDriveAPI:GOOGLE_DRIVE_USER_ABOUT];
        }
        else if (senderButton.tag ==101){
            receivedURL = [googleDriveConnector getDataForGoogleDriveAPI:GOOGLE_DRIVE_USER_CHANGES];
        }
        else if (senderButton.tag ==102){
            receivedURL = [googleDriveConnector getDataForGoogleDriveAPI:GOOGLE_DRIVE_USER_APPS];
        }
    }
    else if (delegate.service == 4){
        
        if (senderButton.tag == 100) {
            receivedURL = [picasaConnector getDataForPicasaAPI:PICASA_USER_ABOUT];
        }
        else if (senderButton.tag ==101){
            receivedURL = [picasaConnector getDataForPicasaAPI:PICASA_USER_CHANGES];
        }
        else if (senderButton.tag ==102){
            receivedURL = [picasaConnector getDataForPicasaAPI:PICASA_USER_APPS];
        }
    }
    
    else if (delegate.service == 5){
        
        if (senderButton.tag == 100) {
            receivedURL = [skyDriveConnector getDataForSkyDriveAPI:SKYDRIVE_USER_ABOUT];
        }
        else if (senderButton.tag ==101){
            receivedURL = [skyDriveConnector getDataForSkyDriveAPI:SKYDRIVE_USER_CHANGES];
        }
        else if (senderButton.tag ==102){
            receivedURL = [skyDriveConnector getDataForSkyDriveAPI:SKYDRIVE_USER_APPS];
        }
    }
    else{
        
    }
    
    
    NSLog(@"receivedURL = %@",receivedURL);
    
    
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:receivedURL];
    [authRequest setHTTPMethod:@"GET"];
    
    [self.webView loadRequest:authRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
