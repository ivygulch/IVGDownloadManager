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
     onSuccess:^(NSURLResponse *response, NSData *data){
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionValidURL)];
     }
     onFailure:^(NSError* error) {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionValidURL)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
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
     onSuccess:^(NSURLResponse *response, NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
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
     onSuccess:^(NSURLResponse *response, NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionFakeURL)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionFakeURL)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
         NSLog(@"testVerifyConnectionInvalidURL, onTimeout");
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionFakeURL)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testHead
{   [self prepare];
    
    [downloadManager_ 
     headFor:@"test1.txt"
     withTimeout:kTestTimeout
     onSuccess:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testHead, onSuccess: %@", dataStr);
         if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
             NSLog(@"allHeaders:\n%@", [(NSHTTPURLResponse*)response allHeaderFields]);
         }
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testHead)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testHead, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testHead)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testHead, onTimeout: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testHead)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testGet
{   [self prepare];
    
    [downloadManager_ 
     getFor:@"test1.txt"
     withTimeout:kTestTimeout
     onSuccess:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGet, onSuccess: %@", dataStr);
         if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
             NSLog(@"allHeaders:\n%@", [(NSHTTPURLResponse*)response allHeaderFields]);
         }
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGet)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testGet, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGet)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGet, onTimeout: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGet)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}


@end
