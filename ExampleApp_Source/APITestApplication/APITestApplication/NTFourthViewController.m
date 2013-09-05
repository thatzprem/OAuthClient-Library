//
//  NTFourthViewController.m
//  APITestApplication
//
//  Created by Prem kumar on 25/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import "NTFourthViewController.h"
#import "NTView.h"
#import "TwitterConnector.h"

@interface NTFourthViewController ()
{
    TwitterConnector *twitterManager;
}
@property (strong, nonatomic) IBOutlet NTView *view;
@property (strong, nonatomic) NSString *authenticate;
@end

@implementation NTFourthViewController

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
    
    self.view = [NTView loadView];
    
    [self.view.segmentControl setEnabled:NO forSegmentAtIndex:1];
    [self.view.segmentControl setEnabled:NO forSegmentAtIndex:2];
    [self.view.segmentControl setEnabled:NO forSegmentAtIndex:3];
    
    self.view.navigationBar.title = @"Twitter";
    
    [self.view.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    self.view.authenticationStatusLabel.text = @"User Status: Not Authenticated!";
    self.authenticate = @"NOT AUTHENTICATED";
//    [self login];
    
    
}

-(void)login
{
    
    self.view.authenticationStatusLabel.text = @"Authenticating...Please wait...";

    self.view.textView.hidden = YES;
    self.view.webView.hidden=NO;
    twitterManager =  [[TwitterConnector alloc]initWithConsumerKey:@"HBJVaYTlusXHM4zrLrt6EQ" secret:@"h6y3TIBbZanFa5ChW8047w54fmTHsmLK8LpriypEiw" webViewToAuthorize:self.view.webView confirmation:^(BOOL confirm) {
        
        if(confirm)
        {
            [self setupViewForAuthentication];
        }
        else{
            
            [self setUpFailedAithentication];
        }
        
    }];
}

-(void) setupViewForAuthentication
{
    
    self.authenticate = @"AUTHENTICATED";
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Flickr Service"
                                                        message:@"Authenticated!" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    self.view.webView.hidden = YES;
    
    self.view.authenticationStatusLabel.text = @"User Status: Authenticated!";
    
    
    [self.view.segmentControl setEnabled:YES forSegmentAtIndex:1];
    [self.view.segmentControl setEnabled:YES forSegmentAtIndex:2];
    [self.view.segmentControl setEnabled:YES forSegmentAtIndex:3];
}


-(void) setUpFailedAithentication
{
    
    self.authenticate = @"NOT AUTHENTICATED";
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Flickr Service"
                                                        message:@"Authenticated failed!" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    self.view.webView.hidden = YES;
    
    self.view.authenticationStatusLabel.text = @"User Status: Authenticated failed!";
    
    
    [self.view.segmentControl setEnabled:NO forSegmentAtIndex:1];
    [self.view.segmentControl setEnabled:NO forSegmentAtIndex:2];
    [self.view.segmentControl setEnabled:NO forSegmentAtIndex:3];
}


-(void)segmentAction:(id)sender
{
    if(self.view.segmentControl.selectedSegmentIndex == 0)
    {
        if([self.authenticate isEqualToString:@"NOT AUTHENTICATED"])
        {
            [self login];
        }
        else{
            
            [self setupViewForAuthentication];
        }
    }
    else if(self.view.segmentControl.selectedSegmentIndex == 1)
    {
        [self getUserProfile];
    }
    else if(self.view.segmentControl.selectedSegmentIndex == 2)
    {
        [self getFrienList];
    }
    else if(self.view.segmentControl.selectedSegmentIndex == 3)
    {
        [self getActivty];
    }
}

-(void)getUserProfile
{
    self.view.textView.hidden = NO;
    [twitterManager getUserProfile:^(NSString *details) {
        
        self.view.textView.text = [NSString stringWithFormat:@"User DETAILS:%@",details];
    }];
}

-(void) getFrienList
{
    self.view.textView.hidden = NO;
    [twitterManager getUserFollowerList:^(NSString *details) {
        
        self.view.textView.text = [NSString stringWithFormat:@"User Friends:%@",details];
    } ];
}

-(void) getActivty
{
    self.view.textView.hidden = NO;
    [twitterManager getUserTimeLineList:^(NSString *confirm) {
        
        self.view.textView.text = [NSString stringWithFormat:@"User Recent Activty:%@",confirm];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
