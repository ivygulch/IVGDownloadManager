//
//  IVGDownloadManagerTests.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"
#import "IVGDMConstants.h"

#define kTestBaseURL @"http://ivygulch.com/test/IVGDownloadManagerTests"
#define kTestTimeout 5.0

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

- (void)testVerifyConnectionValidURL
{
    [self prepare];
    
    [downloadManager_ 
     verifyConnectionWithTimeout:kTestTimeout
     onSuccess:^{
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionValidURL)];
     }
     onFailure:^(NSError* error) {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionValidURL)];
     }
     onTimeout:^{
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionValidURL)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testVerifyConnectionInvalidURL 
{
    [downloadManager_ release];
    downloadManager_ = [[IVGDownloadManager alloc] initWithBaseURL:@"No such URL"];

    [self prepare];
    
    [downloadManager_ 
     verifyConnectionWithTimeout:kTestTimeout
     onSuccess:^{
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     onFailure:^(NSError* error) {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     onTimeout:^{
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionInvalidURL)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}


@end
