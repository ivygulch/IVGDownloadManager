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

@end
