//
//  NTThirdViewController.h
//  APITestApplication
//
//  Created by Prem kumar on 22/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTThirdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

-(IBAction)refresh:(id)sender;

@end
