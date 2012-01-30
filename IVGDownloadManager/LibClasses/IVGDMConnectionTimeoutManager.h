//
//  IVGDMConnectionTimeoutManager.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/30/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGDMConstants.h"

@protocol IVGDMConnectionTimeoutDelegate<NSObject>
- (void) connectionTimeout:(NSURLConnection *) connection;
@end

@interface IVGDMConnectionTimeoutManager : NSObject

@property (nonatomic,assign) id<IVGDMConnectionTimeoutDelegate> delegate;

- (void) startMonitoringConnection:(NSURLConnection *) connection 
                        forTimeout:(NSTimeInterval) timeout;
- (void) stopMonitoringConnection:(NSURLConnection *) connection;
- (void) keepAlive:(NSURLConnection *) connection;

@end
