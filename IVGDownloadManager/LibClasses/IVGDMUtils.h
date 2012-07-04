//
//  IVGDMUtils.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/31/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGDMUtils : NSObject

+ (id) connectionAsKey:(NSURLConnection *) connection;
+ (id) keyAsConnection:(id) key;
+ (NSDictionary *)allHeaderFields:(NSURLResponse *) response;

+ (NSDateFormatter *) sharedDateFormatter;
+ (NSString *) stringFromDate:(NSDate *) value withFormat:(NSString *) format;
+ (NSDate *) dateFromString:(NSString *) value withFormat:(NSString *) format;
+ (NSDate *) lastModified:(NSURLResponse *) response;
+ (NSUInteger) httpStatusCode:(NSURLResponse *) response;

@end
