//
//  NTFirstViewController.m
//  APITestApplication
//
//  Created by Prem kumar on 21/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import "NTFirstViewController.h"
#import "GoogleConnector.h"


@interface NTFirstViewController (){
     
    GoogleConnector *googleConnector;
}
@end

@implementation NTFirstViewController
@synthesize webView;
@synthesize statusLabel;
@synthesize segmentControl;




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"googleSuccessNotification"
                                               object:nil];
    
    
//    googleConnector = [[GoogleConnector alloc] initWithAuthorizingWebView:self.webView];
    
    statusLabel.text = @"User Status: Not Authenticated!";

}

- (void)receiveTestNotification:(NSNotification *) notification{

    [self performSelectorOnMainThread:@selector(updateText:) withObject:nil waitUntilDone:YES
     ];
    
}

-(void)updateText:(id)sender{
    
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Google+ Service"
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

        googleConnector = [[GoogleConnector alloc] initWithAuthorizingWebView:self.webView];
        
        statusLabel.text = @"Authenticating...Please Wait...!";

        return;
        
    }
    else if (senderButton.selectedSegmentIndex == 1) {
        receivedURL = [googleConnector getDataForGoogleAPI:GOOGLE_USER_ABOUT];
    }
    else if (senderButton.selectedSegmentIndex == 2){
        receivedURL = [googleConnector getDataForGoogleAPI:GOOGLE_USER_FRIENDS];
    }
    else if (senderButton.selectedSegmentIndex == 3){
        receivedURL = [googleConnector getDataForGoogleAPI:GOOGLE_USER_MOMENTS];
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
