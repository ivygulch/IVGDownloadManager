//
//  IVGDownloadManager.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"
#import "IVGDMConnectionBlockMap.h"
#import "IVGDMUtils.h"

@interface IVGDownloadManager()
@property (nonatomic,retain) IVGDMConnectionBlockMap *connectionBlockMap;
@property (nonatomic,retain) IVGDMConnectionTimeoutManager *connectionTimeoutManager;
@property (nonatomic,retain) NSMutableDictionary *connectionDataMap;
@property (nonatomic,retain) NSMutableDictionary *connectionResponseMap;
@end

@implementation IVGDownloadManager

@synthesize connectionBlockMap = connectionBlockMap_;
@synthesize connectionTimeoutManager = connectionTimeoutManager_;
@synthesize connectionDataMap = connectionDataMap_;
@synthesize connectionResponseMap = connectionResponseMap_;
@synthesize baseURL = baseURL_;

- (id)initWithBaseURL:(NSString *) baseURL;
{
    self = [super init];
    if (self) {
        baseURL_ = [baseURL copy];
        connectionBlockMap_ = [[IVGDMConnectionBlockMap alloc] init];
        connectionTimeoutManager_ = [[IVGDMConnectionTimeoutManager alloc] init];
        connectionTimeoutManager_.delegate = self;
        connectionDataMap_ = [[NSMutableDictionary alloc] init];
        connectionResponseMap_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc 
{
    [baseURL_ release], baseURL_ = nil;
    [connectionBlockMap_ release], connectionBlockMap_ = nil;
    connectionTimeoutManager_.delegate = nil;
    [connectionTimeoutManager_ release], connectionTimeoutManager_ = nil;
    [connectionDataMap_ release], connectionDataMap_ = nil;
    [connectionResponseMap_ release], connectionResponseMap_ = nil;
    
    [super dealloc];
}

- (void) createDataForConnection:(NSURLConnection *) connection 
{
    id ucKey = [IVGDMUtils connectionAsKey:connection];
    [self.connectionDataMap setObject:[NSMutableData data] forKey:ucKey];
}

- (NSMutableData *) dataForConnection:(NSURLConnection *) connection
{
    id ucKey = [IVGDMUtils connectionAsKey:connection];
    return [self.connectionDataMap objectForKey:ucKey];
}

- (NSURLResponse *) responseForConnection:(NSURLConnection *) connection
{
    id ucKey = [IVGDMUtils connectionAsKey:connection];
    return [self.connectionResponseMap objectForKey:ucKey];
}

- (void) cleanupConnection:(NSURLConnection *) connection 
{
    id ucKey = [IVGDMUtils connectionAsKey:connection];
    [self.connectionDataMap removeObjectForKey:ucKey];
    [self.connectionResponseMap removeObjectForKey:ucKey];
    [self.connectionTimeoutManager stopMonitoringConnection:connection];
    [connection release];    
}

- (void) connectionSuccess:(NSURLConnection *) connection 
{
    IVGDMSuccessBlock successBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeSuccess forConnection:connection];    
    if (successBlock) {
        NSURLResponse *response = [self responseForConnection:connection];
        NSMutableData *data = [self dataForConnection:connection];
        successBlock(response, data);
    }
    [self cleanupConnection:connection];
}

- (void) connectifailureBlock:(NSURLConnection *) connection error:(NSError *) error; 
{
    IVGDMErrorBlock errorBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeFailure forConnection:connection];    
    if (errorBlock) {
        errorBlock(error);
    }
    [self cleanupConnection:connection];
}

- (void) connectionTimeout:(NSURLConnection *) connection {
    [connection cancel];
    IVGDMTimeoutBlock timeoutBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeTimeout forConnection:connection];    
    if (timeoutBlock) {
        NSURLResponse *response = [self responseForConnection:connection];
        NSMutableData *data = [self dataForConnection:connection];
        timeoutBlock(response, data);
    }
    [self cleanupConnection:connection];
}

- (void) startRequest:(NSURLRequest *) request
          withTimeout:(NSTimeInterval) timeout
         successBlock:(IVGDMSuccessBlock) successBlock 
         failureBlock:(IVGDMErrorBlock) failureBlock
         timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    NSLog(@"startRequest: %@, %@", [request HTTPMethod], [request URL]);
    
    // only store data that will be returned via a success or timeout block
    // wasted effort and memory to do otherwise since it would never be used
    if ((successBlock != nil) || (timeoutBlock != nil)) {
        [self createDataForConnection:connection];
    }
    
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


- (NSMutableURLRequest *) requestWithRelativeURI:(NSString *) relativeURI parameters:(NSDictionary *) params 
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
    return [NSMutableURLRequest requestWithURL:url];
}

- (void) verifyConnectionWithTimeout:(NSTimeInterval) timeout
                        successBlock:(IVGDMSuccessBlock) successBlock 
                        failureBlock:(IVGDMErrorBlock) failureBlock
                        timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;
{
    [self headFor:nil
      withTimeout:timeout
     successBlock:successBlock
     failureBlock:failureBlock
     timeoutBlock:timeoutBlock];
}

- (void) headFor:(NSString *) relativeURI
     withTimeout:(NSTimeInterval) timeout
    successBlock:(IVGDMSuccessBlock) successBlock 
    failureBlock:(IVGDMErrorBlock) failureBlock
    timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSMutableURLRequest *request = [self requestWithRelativeURI:relativeURI parameters:nil];
    [request setHTTPMethod:@"HEAD"];
    [self startRequest:request withTimeout:timeout successBlock:successBlock failureBlock:failureBlock timeoutBlock:timeoutBlock];
}

- (void) getFor:(NSString *) relativeURI
    withTimeout:(NSTimeInterval) timeout
   successBlock:(IVGDMSuccessBlock) successBlock 
   failureBlock:(IVGDMErrorBlock) failureBlock
   timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;
{
    NSMutableURLRequest *request = [self requestWithRelativeURI:relativeURI parameters:nil];
    [request setHTTPMethod:@"GET"];
    [self startRequest:request withTimeout:timeout successBlock:successBlock failureBlock:failureBlock timeoutBlock:timeoutBlock];
}

- (void) getFor:(NSString *) relativeURI
 withCutoffDate:(NSDate *) cutoffDate
        timeout:(NSTimeInterval) timeout
   isNewerBlock:(IVGDMSuccessBlock) isNewerBlock 
isNotNewerBlock:(IVGDMSuccessBlock) notNewerBlock 
   failureBlock:(IVGDMErrorBlock) failureBlock
   timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;
{
    [self headFor:relativeURI
      withTimeout:timeout
     successBlock:^(NSURLResponse *response, NSData *data){
         NSLog(@"getFor:%@ ifNewerThan:%@", relativeURI, cutoffDate); 
         NSDate *lastModifed = [IVGDMUtils lastModified:response];
         NSLog(@"lastModified: %@", lastModifed);
         
         if ([lastModifed compare:cutoffDate] == NSOrderedDescending) {
             [self getFor:relativeURI
              withTimeout:timeout 
             successBlock:isNewerBlock
             failureBlock:failureBlock
             timeoutBlock:timeoutBlock];
         } else {
             if (notNewerBlock != nil) {
                 notNewerBlock(response, data);
             }
         }
     }
     failureBlock:failureBlock
     timeoutBlock:timeoutBlock];
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    NSLog(@"connection:%p didFailWithError:%@", connection, [error localizedDescription]);
    [self connectifailureBlock:connection error:error];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (NSURLRequest *)__connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    NSLog(@"connection:%p willSendRequest:%@ redirectResponse:%@", connection, [request HTTPMethod], redirectResponse);
    if ([[request HTTPMethod] isEqualToString:@"HEAD"]) {
        return request;
    }
    
    NSMutableURLRequest *newRequest = [request mutableCopy];
    [newRequest setHTTPMethod:@"HEAD"];
    return [newRequest autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{    
    NSLog(@"connection:%p didReceiveResponse:%@", connection, response);
    id ucKey = [IVGDMUtils connectionAsKey:connection];
    [self.connectionResponseMap setObject:response forKey:ucKey];
    [[self dataForConnection:connection] setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{    
    NSLog(@"connection:%p didReceiveData:%u", connection, [data length]);
    [[self dataForConnection:connection] appendData:data];
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
{    
    NSLog(@"didSendBodyData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{    
    NSLog(@"connectionDidFinishLoading:%p", connection);
    [self connectionSuccess:connection];
}

@end
