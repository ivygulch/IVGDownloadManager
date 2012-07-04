//
//  IVGDMUtils.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/31/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMUtils.h"

static NSString * const kLastModifiedTimestampFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";

@implementation IVGDMUtils

+ (id) connectionAsKey:(NSURLConnection *) connection;
{
    return [NSValue valueWithPointer:connection];
}

+ (id) keyAsConnection:(id) key;
{
    return [key pointerValue];
}

+ (NSDictionary *)allHeaderFields:(NSURLResponse *) response;
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        return [(NSHTTPURLResponse*)response allHeaderFields];
    } else {
        return nil;
    }
}

+ (NSDateFormatter *) sharedDateFormatter {
    // this is a threadsafe, fast method of creating a singleton or doing other one-time initialization
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *sharedDateFormatter = [dictionary objectForKey:@"sharedDateFormatter"];
    if (!sharedDateFormatter) {
        sharedDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        sharedDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dictionary setObject:sharedDateFormatter forKey:@"sharedDateFormatter"];
    }
    return sharedDateFormatter;
}

+ (NSString *) stringFromDate:(NSDate *) value withFormat:(NSString *) format {
    NSDateFormatter *df = [self sharedDateFormatter];
    [df setDateFormat:format];
    return [df stringFromDate:value];
}

+ (NSDate *) dateFromString:(NSString *) value withFormat:(NSString *) format {
    NSDateFormatter *df = [self sharedDateFormatter];
    [df setDateFormat:format];
    return [df dateFromString:value];
}

+ (NSDate *) lastModified:(NSURLResponse *) response
{
    NSDictionary *headers = [self allHeaderFields:response];
    NSString *lastModifiedStr = [headers objectForKey:@"Last-Modified"];
    NSDate *result = [self dateFromString:lastModifiedStr withFormat:kLastModifiedTimestampFormat];
    IVGDLog(IVGDBG_DEBUG, IVGDBG_CATEGORY_DOWNLOAD, @"lastModifiedStr: %@, result=%@\nfrom headers:\n%@", lastModifiedStr, result, headers);
    return result;
}

+ (NSUInteger) httpStatusCode:(NSURLResponse *) response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        return [(NSHTTPURLResponse*)response statusCode];
    } else {
        return 0;
    }
}



@end
