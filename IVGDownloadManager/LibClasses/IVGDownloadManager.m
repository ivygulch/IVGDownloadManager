//
//  IVGDownloadManager.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"
#import "IVGDMConnectionBlockMap.h"
#import "IVGDMConnectionTimeoutManager.h"

@interface IVGDownloadManager()
@property (nonatomic,retain) IVGDMConnectionBlockMap *connectionBlockMap;
@property (nonatomic,retain) IVGDMConnectionTimeoutManager *connectionTimeoutManager;
@end

@implementation IVGDownloadManager

@synthesize connectionBlockMap = connectionBlockMap_;
@synthesize connectionTimeoutManager = connectionTimeoutManager_;
@synthesize baseURL = baseURL_;

- (id)initWithBaseURL:(NSString *) baseURL;
{
    self = [super init];
    if (self) {
        baseURL_ = [baseURL copy];
        connectionBlockMap_ = [[IVGDMConnectionBlockMap alloc] init];
        connectionTimeoutManager_ = [[IVGDMConnectionTimeoutManager alloc] init];
    }
    return self;
}

- (void) dealloc 
{
    [baseURL_ release], baseURL_ = nil;
    [connectionBlockMap_ release], connectionBlockMap_ = nil;
    [connectionTimeoutManager_ release], connectionTimeoutManager_ = nil;
    
    [super dealloc];
}

- (void) startConnection:(NSURLConnection *) connection withTimeout:(NSTimeInterval) timeout {
    [connection start];
}


- (void) verifyConnectionWithTimeout:(NSTimeInterval) timeout
                           onSuccess:(IVGDMSuccessBlock) successBlock 
                           onFailure:(IVGDMErrorBlock) failureBlock
                           onTimeout:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.baseURL]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [self.connectionBlockMap addBlock:successBlock type:kIVGDMBlockTypeSuccess forConnection:connection];
    [self.connectionBlockMap addBlock:failureBlock type:kIVGDMBlockTypeFailure forConnection:connection];
    [self.connectionBlockMap addBlock:timeoutBlock type:kIVGDMBlockTypeTimeout forConnection:connection];

    [self startConnection:connection withTimeout:timeout];
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{    
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
{    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{    
}

@end
