//
//  IVGDownloadManager.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGDMConstants.h"

@interface IVGDownloadManager : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,copy) NSString* baseURL;

- (id)initWithBaseURL:(NSString *) baseURL;
- (void) verifyConnectionWithTimeout:(NSTimeInterval) timeout
                           onSuccess:(IVGDMSuccessBlock) successBlock 
                           onFailure:(IVGDMErrorBlock) failureBlock
                           onTimeout:(IVGDMTimeoutBlock) timeoutBlock;

@end
