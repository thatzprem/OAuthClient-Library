//
//  NTView.h
//  APITestApplication
//
//  Created by myCompany on 25/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTView : UIView

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UILabel *authenticationStatusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)segmentAction:(id)sender;

+(NTView *)  loadView;
@end
