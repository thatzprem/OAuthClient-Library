//
//  URLConnectionOperation.h
//  OAuth2Client
//
/**
 Created by Prem on 12/03/13.
 Copyright (c) 2013 NexTip Solutions
 This program is not to be copied or distributed without the express written consent of NexTip. All rights reserved.
 */

#import <Foundation/Foundation.h>


@interface OAuth2ClientURLRequestOperation : NSOperation {
  BOOL _isExecuting;
  BOOL _isFinished;
  NSURLRequest *URLRequest;
  NSURLResponse *URLResponse;
  NSURLConnection *URLConnection;
  NSError *connectionError;
  NSMutableData *responseData;
}
@property (nonatomic, strong) NSURLRequest *URLRequest;
@property (nonatomic, strong, readonly) NSURLResponse *URLResponse;
@property (nonatomic, strong, readonly) NSError *connectionError;
@property (nonatomic, strong, readonly) NSData *responseData;

- (id)initWithURLRequest:(NSURLRequest *)request;
- (void)finish;
- (void)cancelImmediately;
@end

@interface OAuth2ClientURLRequestOperation (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)theResponse;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
