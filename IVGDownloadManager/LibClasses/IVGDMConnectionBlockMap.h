//
//  IVGDMConnectionBlockMap.h
//  IVGDMConnectionBlockMap
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGDMConstants.h"

@interface IVGDMConnectionBlockMap : NSObject

- (void) addBlock:(id) block type:(const NSString *) blockType forConnection:(NSURLConnection *) connection;
- (void) removeBlockForType:(const NSString *) blockType forConnection:(NSURLConnection *) connection;
- (void) removeBlocksForConnection:(NSURLConnection *) connection ;
- (id) blockForType:(const NSString *) blockType forConnection:(NSURLConnection *) connection;

@end
