//
//  NTFirstViewController.h
//  APITestApplication
//
//  Created by Prem kumar on 21/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTFirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

-(IBAction)refresh:(id)sender;

@end
