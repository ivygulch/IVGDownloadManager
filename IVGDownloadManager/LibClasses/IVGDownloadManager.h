//
//  IVGDownloadManager.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGDMConstants.h"
#import "IVGDMConnectionTimeoutManager.h"

@interface IVGDownloadManager : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,IVGDMConnectionTimeoutDelegate>

@property (nonatomic,copy) NSString* baseURL;

- (id)initWithBaseURL:(NSString *) baseURL
    startRequestBlock:(IVGDMTEmptyBlock) startRequestBlock
   finishRequestBlock:(IVGDMTEmptyBlock) finishRequestBlock;

- (void) verifyConnectionWithTimeout:(NSTimeInterval) timeout
                        successBlock:(IVGDMSuccessBlock) successBlock 
                        failureBlock:(IVGDMErrorBlock) failureBlock
                        timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;

- (void) headFor:(NSString *) relativeURI
     withTimeout:(NSTimeInterval) timeout
    successBlock:(IVGDMSuccessBlock) successBlock 
    failureBlock:(IVGDMErrorBlock) failureBlock
    timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;

- (void) getFor:(NSString *) relativeURI
    withTimeout:(NSTimeInterval) timeout
   successBlock:(IVGDMSuccessBlock) successBlock 
   failureBlock:(IVGDMErrorBlock) failureBlock
   timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;

- (void) getFor:(NSString *) relativeURI
 withCutoffDate:(NSDate *) cutoffDate
        timeout:(NSTimeInterval) timeout
   isNewerBlock:(IVGDMSuccessBlock) isNewerBlock 
notNewerBlock:(IVGDMSuccessBlock) notNewerBlock 
   failureBlock:(IVGDMErrorBlock) failureBlock
   timeoutBlock:(IVGDMTimeoutBlock) timeoutBlock;

@end
