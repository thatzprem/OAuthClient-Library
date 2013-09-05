//
//  NTThirdViewController.m
//  APITestApplication
//
//  Created by Prem kumar on 22/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import "NTNinthViewController.h"
#import "PicasaConnector.h"

@interface NTNinthViewController (){
    
    PicasaConnector *picasaConnector;
    
}

@end

@implementation NTNinthViewController
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
                                                 name:@"picasaSuccessNotification"
                                               object:nil];
    
    //    picasaConnector = [[FaceBookConnector alloc] initWithAuthorizingWebView:self.webView];
    statusLabel.text = @"User Status: Not Authenticated!";
    
    
}
- (void)receiveTestNotification:(NSNotification *) notification{
    
    [self performSelectorOnMainThread:@selector(updateText:) withObject:nil waitUntilDone:YES
     ];
    
}

-(void)updateText:(id)sender{
    
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Picasa Service"
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
        picasaConnector = [[PicasaConnector alloc] initWithAuthorizingWebView:self.webView];
        
        statusLabel.text = @"Authenticating...Please Wait...!";
        
        return;
        
    }
    else if (senderButton.selectedSegmentIndex == 1) {
        receivedURL = [picasaConnector getDataForPicasaAPI:PICASA_USER_ABOUT];
    }
    else if (senderButton.selectedSegmentIndex == 2){
        receivedURL = [picasaConnector getDataForPicasaAPI:PICASA_USER_CHANGES];
    }
    else if (senderButton.selectedSegmentIndex == 3){
        receivedURL = [picasaConnector getDataForPicasaAPI:PICASA_USER_APPS];
    }
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:receivedURL];
    [authRequest setHTTPMethod:@"GET"];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning..."
                                                        message:@"Safari do not support displaying picasa feeds data !" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

    
    NSMutableURLRequest *authRequest1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"www.picasa.com"]];

    [self.webView loadRequest:authRequest1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
