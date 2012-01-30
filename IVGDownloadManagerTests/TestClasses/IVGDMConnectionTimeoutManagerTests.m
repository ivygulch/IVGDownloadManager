//
//  IVGDMConnectionTimeoutManagerTests.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/30/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMConnectionTimeoutManager.h"
#import "IVGDMConstants.h"

#define kTestTimeout 10.0

@interface IVGDMConnectionTimeoutManagerTests : GHAsyncTestCase
{
    IVGDMConnectionTimeoutManager *connectionTimeoutManager_;
    NSURLConnection *dummyConnection_;
}
@end

@implementation IVGDMConnectionTimeoutManagerTests

- (BOOL) __shouldRunOnMainThread {
    return YES; // NSTimer needs the main thread
}

- (void) setUp
{
	connectionTimeoutManager_ = [[IVGDMConnectionTimeoutManager alloc] init];
    dummyConnection_ = [[NSURLConnection alloc] init];
}

- (void) tearDown
{
    [connectionTimeoutManager_ stopMonitoringConnection:dummyConnection_];
    [dummyConnection_ release];
	[connectionTimeoutManager_ release];
}

- (void) testTimeoutShouldOccur
{
    [self prepare];
    
    [connectionTimeoutManager_ 
     startMonitoringConnection:dummyConnection_ 
     forTimeout:kTestTimeout
     onTimeout:^{
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testTimeoutShouldOccur)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void) testTimeoutShouldNotOccur
{
    [self prepare];
    
    [connectionTimeoutManager_ 
     startMonitoringConnection:dummyConnection_ 
     forTimeout:kTestTimeout*2
     onTimeout:^{
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testTimeoutShouldNotOccur)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout];
}

@end
