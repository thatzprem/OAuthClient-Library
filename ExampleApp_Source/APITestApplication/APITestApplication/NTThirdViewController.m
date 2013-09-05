//
//  NTThirdViewController.m
//  APITestApplication
//
//  Created by Prem kumar on 22/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import "NTThirdViewController.h"
#import "FaceBookConnector.h"

@interface NTThirdViewController (){
    
    FaceBookConnector *faceBookConnector;
    
}

@end

@implementation NTThirdViewController
@synthesize statusLabel;
@synthesize segmentControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"facebookSuccessNotification"
                                               object:nil];
    
//    faceBookConnector = [[FaceBookConnector alloc] initWithAuthorizingWebView:self.webView];
    statusLabel.text = @"User Status: Not Authenticated!";


}
- (void)receiveTestNotification:(NSNotification *) notification{
    
    [self performSelectorOnMainThread:@selector(updateText:) withObject:nil waitUntilDone:YES
     ];
    
}

-(void)updateText:(id)sender{
    
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"FaceBook Service"
                                                        message:@"Authenticated!" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    self.webView.hidden = YES;
    
    statusLabel.text = @"User Status: Authenticated!";
    
    
    [self.segmentControl setEnabled:YES forSegmentAtIndex:1];
    [self.segmentControl setEnabled:YES forSegmentAtIndex:2];
    [self.segmentControl setEnabled:YES forSegmentAtIndex:3];
}


-(IBAction)refresh:(id)sender{
    
    
    self.webView.hidden = NO;

    NSURL* receivedURL = [[NSURL alloc] init];
    
    UISegmentedControl *senderButton = sender;
    
    NSLog(@"%d",senderButton.selectedSegmentIndex);
    
    if (senderButton.selectedSegmentIndex == 0) {
        faceBookConnector = [[FaceBookConnector alloc] initWithAuthorizingWebView:self.webView];
        
        statusLabel.text = @"Authenticating...Please Wait...!";

        return;
        
    }
    else if (senderButton.selectedSegmentIndex == 1) {
        receivedURL = [faceBookConnector getDataForFaceBookAPI:FACEBOOK_USER_ABOUT];
    }
    else if (senderButton.selectedSegmentIndex == 2){
        receivedURL = [faceBookConnector getDataForFaceBookAPI:FACEBOOK_USER_FRIENDS];
    }
    else if (senderButton.selectedSegmentIndex == 3){
        receivedURL = [faceBookConnector getDataForFaceBookAPI:FACEBOOK_USER_PHOTOS];
    }
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
