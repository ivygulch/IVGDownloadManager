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
     onSuccess:^(NSData *data){
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionValidURL)];
     }
     onFailure:^(NSError* error) {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionValidURL)];
     }
     onTimeout:^(NSData *data){
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
     onSuccess:^(NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     onTimeout:^(NSData *data){
         NSLog(@"testVerifyConnectionInvalidURL, onTimeout");
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionInvalidURL)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testVerifyConnectionFakeURL
{
    [downloadManager_ release];
    downloadManager_ = [[IVGDownloadManager alloc] initWithBaseURL:@"http://validurlthatdoesnotexist.really"];
    
    [self prepare];
    
    [downloadManager_ 
     verifyConnectionWithTimeout:kTestTimeout
     onSuccess:^(NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionFakeURL)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionFakeURL)];
     }
     onTimeout:^(NSData *data){
         NSLog(@"testVerifyConnectionInvalidURL, onTimeout");
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionFakeURL)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testHead
{
    [downloadManager_ release];
    downloadManager_ = [[IVGDownloadManager alloc] initWithBaseURL:kTestBaseURL];
    
    [self prepare];
    
    [downloadManager_ 
     headFor:@"test1.txt"
     withTimeout:kTestTimeout
     onSuccess:^(NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testHead)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testHead)];
     }
     onTimeout:^(NSData *data){
         NSLog(@"testVerifyConnectionInvalidURL, onTimeout");
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testHead)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}


@end
