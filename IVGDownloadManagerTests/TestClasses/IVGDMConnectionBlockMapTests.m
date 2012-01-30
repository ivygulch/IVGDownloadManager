//
//  IVGDMConnectionBlockMapTests.m
//  IVGDownloadManager
//
//  Created by Sjoquist Douglas on 1/30/12.
//  Copyright 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGDMConnectionBlockMap.h"
#import "IVGDMConstants.h"

@interface IVGDMConnectionBlockMap(Testing)
@property (nonatomic,retain) NSMutableDictionary *connectionBlockMap;
- (NSMutableDictionary *) getBlockMapForConnection:(NSURLConnection *) connection
                                   createIfMissing:(BOOL) createIfMissing;
@end

@interface IVGDMConnectionBlockMapTests : GHTestCase { 
    IVGDMConnectionBlockMap *connectionBlockMap_;
}
@end

@implementation IVGDMConnectionBlockMapTests

- (void) setUp {
    connectionBlockMap_ = [[IVGDMConnectionBlockMap alloc] init];
    GHAssertEquals([connectionBlockMap_.connectionBlockMap count], (NSUInteger) 0, @"should start empty");
}

- (void) tearDown {
    [connectionBlockMap_ release];
}

typedef NSString* (^TestBlock)();

- (void) testAddGetRemove {
    NSString *expectedResult = @"testAdd";
    TestBlock block = ^{return expectedResult;};
    const NSString *blockType = kIVGDMBlockTypeSuccess;
    NSURLConnection *dummyConnection = [[NSURLConnection alloc] init];
    [connectionBlockMap_ addBlock:block type:blockType forConnection:dummyConnection];
    
    GHAssertEquals([connectionBlockMap_.connectionBlockMap count], (NSUInteger) 1, @"should have one entry");
    NSMutableDictionary *blockMap = [connectionBlockMap_ getBlockMapForConnection:dummyConnection createIfMissing:NO];
    GHAssertEquals([blockMap count], (NSUInteger) 1, @"should have one entry");
    
    TestBlock returnedBlock = [connectionBlockMap_ blockForType:blockType forConnection:dummyConnection];
    GHAssertNotNil(returnedBlock, @"should return a block");

    NSString *actualResult = returnedBlock();
    GHAssertEqualStrings(actualResult, expectedResult, @"returned block should return same value as original");
    
    [connectionBlockMap_ removeBlockForType:blockType forConnection:dummyConnection];
    GHAssertEquals([connectionBlockMap_.connectionBlockMap count], (NSUInteger) 0, @"should have no entries");
    
    TestBlock returnedBlock2 = [connectionBlockMap_ blockForType:blockType forConnection:dummyConnection];
    GHAssertNil(returnedBlock2, @"should not return a block");
    
    [dummyConnection release];
}

@end
