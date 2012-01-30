//
//  IVGDMConstants.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

typedef void (^IVGDMSuccessBlock)();
typedef void (^IVGDMErrorBlock)(NSError *error);
typedef void (^IVGDMTimeoutBlock)();

extern const NSString* kIVGDMBlockTypeSuccess;
extern const NSString* kIVGDMBlockTypeFailure;
extern const NSString* kIVGDMBlockTypeTimeout;

extern const NSTimeInterval kIVGDMTimeoutTimerInterval;