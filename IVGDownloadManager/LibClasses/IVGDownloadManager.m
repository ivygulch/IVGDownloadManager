//
//  IVGDownloadManager.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"
#import "IVGDMConnectionBlockMap.h"

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
        connectionTimeoutManager_.delegate = self;
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

- (void) connectionSuccess:(NSURLConnection *) connection 
{
    IVGDMSuccessBlock successBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeSuccess forConnection:connection];    
    if (successBlock) {
        successBlock();
    }
    [connection release];
}

- (void) connectionFailure:(NSURLConnection *) connection error:(NSError *) error; 
{
    IVGDMErrorBlock errorBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeFailure forConnection:connection];    
    if (errorBlock) {
        errorBlock(error);
    }
    [connection release];
}

- (void) connectionTimeout:(NSURLConnection *) connection {
    [connection cancel];
    IVGDMTimeoutBlock timeoutBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeTimeout forConnection:connection];    
    if (timeoutBlock) {
        timeoutBlock();
    }
    [connection release];
}

- (void) startRequest:(NSURLRequest *) request
          withTimeout:(NSTimeInterval) timeout
            onSuccess:(IVGDMSuccessBlock) successBlock 
            onFailure:(IVGDMErrorBlock) failureBlock
            onTimeout:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];

    [self.connectionBlockMap addBlock:successBlock type:kIVGDMBlockTypeSuccess forConnection:connection];
    [self.connectionBlockMap addBlock:failureBlock type:kIVGDMBlockTypeFailure forConnection:connection];
    [self.connectionBlockMap addBlock:timeoutBlock type:kIVGDMBlockTypeTimeout forConnection:connection];
    [self.connectionTimeoutManager startMonitoringConnection:connection forTimeout:timeout];
    
    [connection start];
}

- (NSString*)urlEscape:(NSString *)unencodedString {
	NSString *s = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (CFStringRef)unencodedString,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                      kCFStringEncodingUTF8);
	return [s autorelease]; // Due to the 'create rule' we own the above and must autorelease it
}


- (NSURLRequest *) requestWithRelativeURI:(NSString *) relativeURI parameters:(NSDictionary *) params 
{
    NSMutableString *urlStr = [NSMutableString stringWithString:self.baseURL];
    if (relativeURI) {
        if (![self.baseURL hasSuffix:@"/"] && ![relativeURI hasPrefix:@"/"]) {
            [urlStr appendString:@"/"];
        }
        [urlStr appendString:relativeURI];
    }
    if ([params count] > 0) {
        NSString *sep = ([urlStr rangeOfString:@"?"].location == NSNotFound) ? @"?" : @"&";
        for (NSString *key in [params keyEnumerator]) {
            NSString *value = [params objectForKey:key];
            [urlStr appendFormat:@"%@%@=%@", sep, [self urlEscape:key], [self urlEscape:value]];
            sep = @"&";
        }
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    return [NSURLRequest requestWithURL:url];
}

- (void) verifyConnectionWithTimeout:(NSTimeInterval) timeout
                           onSuccess:(IVGDMSuccessBlock) successBlock 
                           onFailure:(IVGDMErrorBlock) failureBlock
                           onTimeout:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSURLRequest *request = [self requestWithRelativeURI:nil parameters:nil];
    [self startRequest:request withTimeout:timeout onSuccess:successBlock onFailure:failureBlock onTimeout:timeoutBlock];
}

- (void) getTimestampFor:(NSString *) relativeURI
             withTimeout:(NSTimeInterval) timeout
               onSuccess:(IVGDMSuccessBlock) successBlock 
               onFailure:(IVGDMErrorBlock) failureBlock
               onTimeout:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSURLRequest *request = [self requestWithRelativeURI:relativeURI parameters:nil];
    [self startRequest:request withTimeout:timeout onSuccess:successBlock onFailure:failureBlock onTimeout:timeoutBlock];
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    [self connectionFailure:connection error:error];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{    
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{    
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"didReceiveData: %u/%@", [data length], s);
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
{    
    NSLog(@"didSendBodyData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{    
    [self connectionSuccess:connection];
}

@end
