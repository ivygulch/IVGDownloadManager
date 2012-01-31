//
//  IVGDMConstants.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

typedef void (^IVGDMSuccessBlock)(NSData *data);
typedef void (^IVGDMErrorBlock)(NSError *error);
typedef void (^IVGDMTimeoutBlock)(NSData *data);

extern const NSString* kIVGDMBlockTypeSuccess;
extern const NSString* kIVGDMBlockTypeFailure;
extern const NSString* kIVGDMBlockTypeTimeout;

extern const NSTimeInterval kIVGDMTimeoutTimerInterval;