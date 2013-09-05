//
//  YahooViewController.m
//  SociallyConnecting
//
//  Created by myCompany on 25/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "YahooViewController.h"
#import "NTView.h"
#import "YahooConnector.h"



@interface YahooViewController ()
{
    YahooConnector *yahooConnector;
}

@property (strong, nonatomic) IBOutlet NTView *view;
@property (strong, nonatomic) NSString *authenticate;
@end

@implementation YahooViewController

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
    
    [self.view.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    self.view.authenticationStatusLabel.text = @"Waiting for Authentication! please wait";
    self.authenticate = @"NOT AUTHENTICATED";
    [self login];
    
    
}

-(void)login
{
    self.view.textView.hidden = YES;
    self.view.webView.hidden=NO;
    yahooConnector = [[YahooConnector alloc]initWithConsumerKey:@"dj0yJmk9d09KWDlNU0hxSkZnJmQ9WVdrOVFsbDJjekJXTmpRbWNHbzlNVFF5TnpFd01EVTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD02NQ--" secret:@"bb935dd2cf8badd8bae92f90771c754833f4a3f3"webViewToAuthorize:self.view.webView confirmation:^(BOOL confirm) {
        
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
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Yahoo Service"
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
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Yahoo Service"
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
        [self getFrienList];
    }
}

-(void)getUserProfile
{
    self.view.textView.hidden = NO;
    [yahooConnector getUserProfile:^(NSString *details) {
        
        self.view.textView.text = [NSString stringWithFormat:@"User DETAILS:%@",details];
    }];
}

-(void) getFrienList
{
    self.view.textView.hidden = NO;
    [yahooConnector getUseFriendList:^(NSString *details) {
        
        self.view.textView.text = [NSString stringWithFormat:@"User Friends:%@",details];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
