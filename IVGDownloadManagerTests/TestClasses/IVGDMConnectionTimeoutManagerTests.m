//
//  IVGDMConnectionTimeoutManagerTests.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/30/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMConnectionTimeoutManager.h"
#import "IVGDMConstants.h"

#define kTestTimeout 5.0

@interface IVGDMConnectionTimeoutManagerTests : GHAsyncTestCase<IVGDMConnectionTimeoutDelegate>
{
    IVGDMConnectionTimeoutManager *connectionTimeoutManager_;
    NSURLConnection *dummyConnection_;
    int connectionTimeoutWaitStatus_;
    SEL connectionTimeoutSelector_;
}
@end

@implementation IVGDMConnectionTimeoutManagerTests

- (void) setUp
{
	connectionTimeoutManager_ = [[IVGDMConnectionTimeoutManager alloc] init];
    connectionTimeoutManager_.delegate = self;
    dummyConnection_ = [[NSURLConnection alloc] init];
}

- (void) tearDown
{
    [connectionTimeoutManager_ stopMonitoringConnection:dummyConnection_];
    [dummyConnection_ release];
	[connectionTimeoutManager_ release];
}

- (void) connectionTimeout:(NSURLConnection *) connection;
{
    [self notify:connectionTimeoutWaitStatus_ forSelector:connectionTimeoutSelector_];
}

- (void) testTimeoutShouldOccur
{
    [self prepare];
    
    connectionTimeoutWaitStatus_ = kGHUnitWaitStatusSuccess;
    connectionTimeoutSelector_ = @selector(testTimeoutShouldOccur);
    [connectionTimeoutManager_ startMonitoringConnection:dummyConnection_ forTimeout:kTestTimeout];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void) testTimeoutShouldNotOccur
{
    [self prepare];

    connectionTimeoutWaitStatus_ = kGHUnitWaitStatusFailure;
    connectionTimeoutSelector_ = @selector(testTimeoutShouldNotOccur);
    [connectionTimeoutManager_ startMonitoringConnection:dummyConnection_ forTimeout:kTestTimeout*2];
    
    [self waitForTimeout:kTestTimeout];
}

@end
