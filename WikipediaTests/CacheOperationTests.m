//
//  CacheOperationTests.m
//  Wikipedia
//
//  Created by A647700 on 9/5/15.
//  Copyright (c) 2015 A647700. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CacheOperation.h"
#import "PersistenceController.h"
#import "Search+Helpers.h"
#import "XCTestCase+Helpers.h"

@interface CacheOperationTests : XCTestCase
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) PersistenceController *persistenceController;
@end

@implementation CacheOperationTests

- (void)setUp {
    [super setUp];
    
    //-- persistent controller
    self.persistenceController = [self createTestPersistenceController];

    //-- data
    self.data = @{
                  @"query": @{
                      @"searchinfo": @{
                          @"totalhits": @(196894)
                      },
                      @"search": @[
                                     @{
                                         @"title": @"Test",
                                         @"timestamp": @"2015-09-03T17:14:52Z"
                                     }
                                 ]
                      }
                  };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheOperation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CacheOperation"];
    
    NSManagedObjectContext *context = [self.persistenceController createWorkerManagedObjectContext];
    
    CacheOperation *operation = [CacheOperation new];
    operation.persistenceController = self.persistenceController;
    operation.searchID = [Search createWithKeywork:@"Test" inContext:context];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    //-- inject data
    [operation didReceiveObject:self.data];
    
    //-- add operation
    [queue addOperation:operation];
    
    __weak CacheOperation *weakOperation = operation;
    operation.completionBlock = ^{
        XCTAssertNil(weakOperation.error);

        [self validateResultInContext:context];
        
        [expectation fulfill];
    };
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

@end
