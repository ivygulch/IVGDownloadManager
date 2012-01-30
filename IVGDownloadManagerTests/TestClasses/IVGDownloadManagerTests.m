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
#define kTestTimeout 10.0

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
     verifyConnectionWithTimeout:kTestTimeout
     onSuccess:^{
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnection)];
     }
     onFailure:^(NSError* error) {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnection)];
     }
     onTimeout:^{
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnection)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}


@end
