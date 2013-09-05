//
//  HMViewController.h
//  HMOAuth2ClientApplication
//
//  Created by Prem kumar on 18/04/13.
//  Copyright (c) 2013 NexTip . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(IBAction)refresh:(id)sender;


@end