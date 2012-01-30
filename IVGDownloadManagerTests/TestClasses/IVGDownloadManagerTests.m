//
//  IVGDownloadManagerTests.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"

#define kTestBaseURL @"http://ivygulch.com/test/IVGDownloadManagerTests"

@interface IVGDownloadManagerTests : GHAsyncTestCase {
    IVGDownloadManager *downloadManager_;
}
@end

@implementation IVGDownloadManagerTests

- (void)setUp
{
    downloadManager_ = [[IVGDownloadManager alloc] initWithBaseURL:kTestBaseURL];    
}

- (void) tearDown {
    [downloadManager_ release];
}

- (void)testVerifyConnection 
{
    [self prepare];
    
    [downloadManager_ 
     verifyConnectionOnSuccess:^id {
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnection)];
         return nil;
     }
     onError:^NSError* {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnection)];
         return nil;
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

////    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]http://www.google.com"]];
////    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    // Notify of success, specifying the method where wait is called.
//    // This prevents stray notifies from affecting other tests.
//    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testURLConnection)];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    // Notify of connection failure
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    GHTestLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
//} 

@end
