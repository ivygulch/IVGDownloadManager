//
//  IVGDownloadManager.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDownloadManager.h"

@implementation IVGDownloadManager

@synthesize baseURL = baseURL_;

- (id)initWithBaseURL:(NSString *) baseURL
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc 
{
    [baseURL_ release], baseURL_ = nil;
    
    [super dealloc];
}

- (void) verifyConnectionOnSuccess:(IVGDMResultBlock) successBlock onError:(IVGDMErrorBlock) errorBlock;
{
}

@end
