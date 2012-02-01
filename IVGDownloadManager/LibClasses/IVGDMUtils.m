//
//  IVGDMUtils.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/31/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMUtils.h"

@implementation IVGDMUtils

+ (id) connectionAsKey:(NSURLConnection *) connection;
{
    return [NSValue valueWithPointer:connection];
}

+ (id) keyAsConnection:(id) key;
{
    return [key pointerValue];
}

@end
