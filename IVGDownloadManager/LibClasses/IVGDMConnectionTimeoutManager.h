//
//  IVGDMConnectionTimeoutManager.h
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/30/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGDMConstants.h"

@interface IVGDMConnectionTimeoutManager : NSObject

- (void) startMonitoringConnection:(NSURLConnection *) connection 
                        forTimeout:(NSTimeInterval) timeout
                         onTimeout:(IVGDMTimeoutBlock) timeoutBlock;
- (void) stopMonitoringConnection:(NSURLConnection *) connection;
- (void) keepAlive:(NSURLConnection *) connection;

@end
