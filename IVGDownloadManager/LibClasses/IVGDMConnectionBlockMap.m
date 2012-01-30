//
//  IVGDMConnectionBlockMap.m
//  IVGDMConnectionBlockMap
//
//  Created by Sjoquist Douglas on 1/29/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMConnectionBlockMap.h"

@interface IVGDMConnectionBlockMap()
@property (nonatomic,retain) NSMutableDictionary *connectionBlockMap;
@end

@implementation IVGDMConnectionBlockMap

@synthesize connectionBlockMap = connectionBlockMap_;

- (id)init;
{
    self = [super init];
    if (self) {
        connectionBlockMap_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc 
{
    [connectionBlockMap_ release], connectionBlockMap_ = nil;
    
    [super dealloc];
}

- (id) connectionAsKey:(NSURLConnection *) connection {
    return [NSValue valueWithPointer:connection];
}

- (NSMutableDictionary *) getBlockMapForConnection:(NSURLConnection *) connection
                                   createIfMissing:(BOOL) createIfMissing 
{
    id ucKey = [self connectionAsKey:connection];
    NSMutableDictionary *blockMap = [self.connectionBlockMap objectForKey:ucKey];
    if (!blockMap && createIfMissing) {
        blockMap = [NSMutableDictionary dictionary];
        [self.connectionBlockMap setObject:blockMap forKey:ucKey];
    }
    return blockMap;
}

- (void) removeBlockMapForConnection:(NSURLConnection *) connection
{
    id ucKey = [self connectionAsKey:connection];
    [self.connectionBlockMap removeObjectForKey:ucKey];
}

- (void) removeBlockForType:(const NSString *) blockType fromMap:(NSMutableDictionary *) blockMap
{
    NSValue *blockRef = [blockMap objectForKey:blockType];
    if (blockRef) {
        id block = [blockRef pointerValue];
        Block_release(block);
        [blockMap removeObjectForKey:blockType];
    }
}

- (id) blockForType:(const NSString *) blockType inMap:(NSMutableDictionary *) blockMap
{
    id block = nil;
    NSValue *blockRef = [blockMap objectForKey:blockType];
    if (blockRef) {
        block = [blockRef pointerValue];
    }
    return block;
}

- (void) addBlock:(id) block type:(const NSString *) blockType toMap:(NSMutableDictionary *) blockMap
{
    if (!block) {
        return;
    }
    
    NSValue *blockRef = [NSValue valueWithPointer:Block_copy(block)];
    [blockMap setObject:blockRef forKey:blockType];
}

- (void) addBlock:(id) block type:(const NSString *) blockType forConnection:(NSURLConnection *) connection
{
    if (!block) {
        return;
    }
        
    NSMutableDictionary *blockMap = [self getBlockMapForConnection:connection createIfMissing:YES];
    [self removeBlockForType:blockType fromMap:blockMap]; // remove any previous block for connection
    [self addBlock:block type:blockType toMap:blockMap];
}

- (void) removeBlocksForConnection:(NSURLConnection *) connection 
{
    NSMutableDictionary *blockMap = [self getBlockMapForConnection:connection createIfMissing:NO];
    for (const NSString *key in [blockMap keyEnumerator]) {
        [self removeBlockForType:key fromMap:blockMap];
    }
    if ([blockMap count] == 0) {
        [self removeBlockMapForConnection:connection];
    }
}

- (void) removeBlockForType:(const NSString *) blockType forConnection:(NSURLConnection *) connection 
{
    NSMutableDictionary *blockMap = [self getBlockMapForConnection:connection createIfMissing:NO];
    [self removeBlockForType:blockType fromMap:blockMap];
    if ([blockMap count] == 0) {
        [self removeBlockMapForConnection:connection];
    }
}

- (id) blockForType:(const NSString *) blockType forConnection:(NSURLConnection *) connection 
{
    NSMutableDictionary *blockMap = [self getBlockMapForConnection:connection createIfMissing:NO];
    return [self blockForType:blockType inMap:blockMap];
}

@end