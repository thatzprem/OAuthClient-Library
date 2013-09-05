//
//  NTView.m
//  APITestApplication
//
//  Created by myCompany on 25/05/13.
//  Copyright (c) 2013 NexTip. All rights reserved.
//

#import "NTView.h"

@implementation NTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(NTView *)  loadView
{
    
    NTView *viiew;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NTView" owner:self options:nil];
    
    if(array)
    {
        viiew = [array objectAtIndex:0];
    }
    
    return viiew;
}


- (IBAction)segmentAction:(id)sender {
}
@end
