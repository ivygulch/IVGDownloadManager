//
//  IVGDMConnectionTimeoutManager.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/30/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMConnectionTimeoutManager.h"
#import "IVGDMConnectionBlockMap.h"

@interface IVGDMConnectionTimeoutManager()
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSMutableDictionary *connectionTimestampMap;
@property (nonatomic,retain) NSMutableDictionary *connectionTimeoutMap;
@end

@implementation IVGDMConnectionTimeoutManager

@synthesize delegate = delegate_;
@synthesize timer = timer_;
@synthesize connectionTimestampMap = connectionTimestampMap_;
@synthesize connectionTimeoutMap = connectionTimeoutMap_;

- (id)init;
{
    self = [super init];
    if (self) {
        connectionTimestampMap_ = [[NSMutableDictionary alloc] init];
        connectionTimeoutMap_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc 
{
    delegate_ = nil;
    [timer_ release], timer_ = nil;
    [connectionTimestampMap_ release], connectionTimestampMap_ = nil;
    [connectionTimeoutMap_ release], connectionTimeoutMap_ = nil;
    
    [super dealloc];
}

- (id) connectionAsKey:(NSURLConnection *) connection {
    return [NSValue valueWithPointer:connection];
}

- (void) handleConnectionTimeout:(NSURLConnection *) connection;
{
    [self stopMonitoringConnection:connection];
    [self.delegate connectionTimeout:connection];
}

- (void) checkConnectionTimeout:(NSURLConnection *) connection forDate:(NSDate *) checkDate;
{
    id ucKey = [self connectionAsKey:connection];
    NSDate *lastTimestamp = [self.connectionTimestampMap objectForKey:ucKey];
    NSTimeInterval timeout = [[self.connectionTimeoutMap objectForKey:ucKey] doubleValue];
    NSDate *timeoutTimestamp = [NSDate dateWithTimeInterval:timeout sinceDate:lastTimestamp];
    
    if ([timeoutTimestamp compare:checkDate] == NSOrderedAscending) {
        [self handleConnectionTimeout:connection];
    }
}

- (void) timerTick:(NSTimer *) timer {
    NSDate *now = [NSDate date];
    NSSet *keys = [NSSet setWithArray:[self.connectionTimestampMap allKeys]];
    for (id ucKey in keys) {
        NSURLConnection *connection = [ucKey pointerValue];
        [self checkConnectionTimeout:connection forDate:now];
    }
}

- (void) checkTimer {
    if (self.timer) {
        if ([self.connectionTimestampMap count] == 0) {
            [self.timer invalidate];
            self.timer = nil;
        }
    } else {
        if ([self.connectionTimestampMap count] > 0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:kIVGDMTimeoutTimerInterval
                                                 target:self
                                               selector:@selector(timerTick:)
                                               userInfo:nil
                                                repeats:YES];
        }
    }
}

- (void) startMonitoringConnection:(NSURLConnection *) connection 
                        forTimeout:(NSTimeInterval) timeout
{
    id ucKey = [self connectionAsKey:connection];
    [self.connectionTimeoutMap setObject:[NSNumber numberWithDouble:timeout] forKey:ucKey];
    [self.connectionTimestampMap setObject:[NSDate date] forKey:ucKey];
    [self checkTimer];
}

- (void) stopMonitoringConnection:(NSURLConnection *) connection;
{
    id ucKey = [self connectionAsKey:connection];
    [self.connectionTimestampMap removeObjectForKey:ucKey];
    [self.connectionTimeoutMap removeObjectForKey:ucKey];
    [self checkTimer];
}

- (void) keepAlive:(NSURLConnection *) connection;
{
    [self.connectionTimestampMap setObject:[NSDate date] forKey:[self connectionAsKey:connection]];
    [self checkTimer];
}

@end
