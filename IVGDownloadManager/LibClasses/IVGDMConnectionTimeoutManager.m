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
@property (nonatomic,retain) IVGDMConnectionBlockMap *connectionBlockMap;
@end

@implementation IVGDMConnectionTimeoutManager

@synthesize timer = timer_;
@synthesize connectionTimestampMap = connectionTimestampMap_;
@synthesize connectionTimeoutMap = connectionTimeoutMap_;
@synthesize connectionBlockMap = connectionBlockMap_;

- (id)init;
{
    self = [super init];
    if (self) {
        connectionTimestampMap_ = [[NSMutableDictionary alloc] init];
        connectionTimeoutMap_ = [[NSMutableDictionary alloc] init];
        connectionBlockMap_ = [[IVGDMConnectionBlockMap alloc] init];
    }
    return self;
}

- (void) dealloc 
{
    [timer_ release], timer_ = nil;
    [connectionTimestampMap_ release], connectionTimestampMap_ = nil;
    [connectionTimeoutMap_ release], connectionTimeoutMap_ = nil;
    [connectionBlockMap_ release], connectionBlockMap_ = nil;
    
    [super dealloc];
}

- (id) connectionAsKey:(NSURLConnection *) connection {
    return [NSValue valueWithPointer:connection];
}

- (void) checkConnectionTimeout:(NSURLConnection *) connection forDate:(NSDate *) checkDate;
{
    id ucKey = [self connectionAsKey:connection];
    NSDate *lastTimestamp = [self.connectionTimestampMap objectForKey:ucKey];
    NSTimeInterval timeout = [[self.connectionTimeoutMap objectForKey:ucKey] doubleValue];
    NSDate *timeoutTimestamp = [NSDate dateWithTimeInterval:timeout sinceDate:lastTimestamp];
    
    if ([timeoutTimestamp compare:checkDate] == NSOrderedAscending) {
        IVGDMTimeoutBlock timeoutBlock = [self.connectionBlockMap blockForType:kIVGDMBlockTypeTimeout forConnection:connection];
        timeoutBlock();
        [self stopMonitoringConnection:connection];
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
                         onTimeout:(IVGDMTimeoutBlock) timeoutBlock;
{
    id ucKey = [self connectionAsKey:connection];
    [self.connectionTimeoutMap setObject:[NSNumber numberWithDouble:timeout] forKey:ucKey];
    [self.connectionBlockMap addBlock:timeoutBlock type:kIVGDMBlockTypeTimeout forConnection:connection];
    [self.connectionTimestampMap setObject:[NSDate date] forKey:ucKey];
    [self checkTimer];
}

- (void) stopMonitoringConnection:(NSURLConnection *) connection;
{
    id ucKey = [self connectionAsKey:connection];
    [self.connectionTimestampMap removeObjectForKey:ucKey];
    [self.connectionBlockMap removeBlockForType:kIVGDMBlockTypeTimeout forConnection:connection];
    [self.connectionTimeoutMap removeObjectForKey:ucKey];
    [self checkTimer];
}

- (void) keepAlive:(NSURLConnection *) connection;
{
    [self.connectionTimestampMap setObject:[NSDate date] forKey:[self connectionAsKey:connection]];
    [self checkTimer];
}

@end
