//
//  IVGDownloadManagerTests.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"
#import "IVGDMConstants.h"
#import "IVGDMUtils.h"

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
     successBlock:^(NSURLResponse *response, NSData *data){
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionValidURL)];
     }
     failureBlock:^(NSError* error) {
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionValidURL)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
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
     successBlock:^(NSURLResponse *response, NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     failureBlock:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, failureBlock: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionInvalidURL)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
         NSLog(@"testVerifyConnectionInvalidURL, timeoutBlock");
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
     successBlock:^(NSURLResponse *response, NSData *data){
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVerifyConnectionFakeURL)];
     }
     failureBlock:^(NSError* error) {
         NSLog(@"testVerifyConnectionInvalidURL, failureBlock: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionFakeURL)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
         NSLog(@"testVerifyConnectionInvalidURL, timeoutBlock");
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVerifyConnectionFakeURL)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testHead
{   [self prepare];
    
    [downloadManager_ 
     headFor:@"test1.txt"
     withTimeout:kTestTimeout
     successBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testHead, successBlock[%u]: %@", [data length], dataStr);
         if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
             NSLog(@"allHeaders:\n%@", [(NSHTTPURLResponse*)response allHeaderFields]);
         }
         if ([data length] == 0) {
             [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testHead)];
         } else{
             NSLog(@"expected data length of 0 in HEAD request, received %d bytes", [data length]);
             [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testHead)];
         }
     }
     failureBlock:^(NSError* error) {
         NSLog(@"testHead, failureBlock: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testHead)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testHead, timeoutBlock: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testHead)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void)testGet
{   [self prepare];
    
    [downloadManager_ 
     getFor:@"test1.txt"
     withTimeout:kTestTimeout
     successBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGet, successBlock: %@", dataStr);
         if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
             NSLog(@"allHeaders:\n%@", [(NSHTTPURLResponse*)response allHeaderFields]);
         }
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGet)];
     }
     failureBlock:^(NSError* error) {
         NSLog(@"testGet, failureBlock: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGet)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGet, timeoutBlock: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGet)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (NSDate *) dateFromYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day
                     hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    [comps setTimeZone:[[NSCalendar currentCalendar] timeZone]];
    NSDate *result = [[NSCalendar currentCalendar] dateFromComponents:comps];
    [comps release];
    return result;
}

- (void)testGetIfNewerThanExpectIsNewer
{   
    [self prepare];
    
    NSDate *cutoffDate = [self dateFromYear:2012 month:1 day:31
                                       hour:04 minute:00 second:00];
    
    [downloadManager_ 
     getFor:@"test1.txt"
     withCutoffDate:cutoffDate
     timeout:kTestTimeout
     isNewerBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectIsNewer, isNewerBlock: %@", dataStr);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }
     isNotNewerBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectIsNewer, isNotNewerBlock: %@", dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }
     failureBlock:^(NSError* error) {
         NSLog(@"testGetIfNewerThanExpectIsNewer, failureBlock: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectIsNewer, timeoutBlock: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}


- (void)testGetIfNewerThanExpectNotNewer
{   
    [self prepare];
    
    NSDate *cutoffDate = [self dateFromYear:2013 month:1 day:31
                                       hour:04 minute:00 second:00];
    
    [downloadManager_ 
     getFor:@"test1.txt"
     withCutoffDate:cutoffDate
     timeout:kTestTimeout
     isNewerBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectNotNewer, isNewerBlock: %@", dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }
     isNotNewerBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectNotNewer, isNotNewerBlock: %@", dataStr);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }
     failureBlock:^(NSError* error) {
         NSLog(@"testGetIfNewerThanExpectNotNewer, failureBlock: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }
     timeoutBlock:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectNotNewer, timeoutBlock: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}

- (void) testGetData {
    [self prepare];
    
    [downloadManager_ getFor:@"test1.txt"
                 withTimeout:kTestTimeout
                successBlock:^(NSURLResponse *response, NSData *data) {
                    NSLog(@"testGetData, successBlock, data: %u", [data length]);
                    GHAssertTrue([data length] > 0, @"Should have received data");
                    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetData)];
                }
                failureBlock:^(NSError *error) {
                    NSLog(@"testGetData, failureBlock");
                    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetData)];
                }
                timeoutBlock:^(NSURLResponse *response, NSData *data) {
                    NSLog(@"testGetData, timeoutBlock");
                    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetData)];
                }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:60];
}

@end
