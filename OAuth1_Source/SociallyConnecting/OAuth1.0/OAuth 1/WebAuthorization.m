//
//  WebAuthorization.m
//  SociallyConnecting
//
//  Created by myCompany on 22/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "WebAuthorization.h"

@interface WebAuthorization () <UIWebViewDelegate>

@end

@implementation WebAuthorization


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:self.authorizedUrl].location != NSNotFound);
    
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {
            [self.requestToken setVerifierWithUrl:url];
            
            if(self.delegate)
            {
                if([self.delegate respondsToSelector:@selector(loadedSuccesfully:)])
                {
                    [self.delegate loadedSuccesfully:self.requestToken];
                }
            }

        }
        else
        {
            
        }
    }
    else
    {
        // Case (a) or (b), so ignore it
        
        //[self errorHandler];
    }
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(loadedSuccesfully:)])
        {
            [self.delegate loadedSuccesfully:nil];
        }
    }
}
@end
