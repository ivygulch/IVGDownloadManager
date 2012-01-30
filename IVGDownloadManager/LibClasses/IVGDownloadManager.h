//
//  IVGDownloadManager.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGDownloadManagerConstants.h"

@interface IVGDownloadManager : NSObject

@property (nonatomic,copy) NSString* baseURL;

- (id)initWithBaseURL:(NSString *) baseURL;
- (void) verifyConnectionOnSuccess:(IVGDMResultBlock) successBlock onError:(IVGDMErrorBlock) errorBlock;

@end
