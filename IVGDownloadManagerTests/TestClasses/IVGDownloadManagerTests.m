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
     onIsNewer:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectIsNewer, onIsNewer: %@", dataStr);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }
     onNotNewer:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectIsNewer, onNotNewer: %@", dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testGetIfNewerThanExpectIsNewer, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectIsNewer)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectIsNewer, onTimeout: [%u], %@", [data length], dataStr);
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
     onIsNewer:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectNotNewer, onIsNewer: %@", dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }
     onNotNewer:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectNotNewer, onNotNewer: %@", dataStr);
         [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }
     onFailure:^(NSError* error) {
         NSLog(@"testGetIfNewerThanExpectNotNewer, onFailure: %@", [error localizedDescription]);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }
     onTimeout:^(NSURLResponse *response, NSData *data){
         NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"testGetIfNewerThanExpectNotNewer, onTimeout: [%u], %@", [data length], dataStr);
         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetIfNewerThanExpectNotNewer)];
     }];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTestTimeout*2];
}


@end
