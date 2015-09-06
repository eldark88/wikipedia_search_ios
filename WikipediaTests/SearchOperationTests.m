//
//  SearchOperationTests.m
//  Wikipedia
//
//  Created by A647700 on 9/6/15.
//  Copyright (c) 2015 A647700. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchOperation.h"
#import "PersistenceController.h"
#import "Search+Helpers.h"
#import "XCTestCase+Helpers.h"

@interface SearchOperationTests : XCTestCase

@property (nonatomic, strong) PersistenceController *persistenceController;

@end

@implementation SearchOperationTests

- (void)setUp {
    [super setUp];
    
    self.persistenceController = [self createTestPersistenceController];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSearchOperation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SearchOperation"];
    
    NSManagedObjectContext *context = [self.persistenceController createWorkerManagedObjectContext];
    
    SearchOperation *operation = [SearchOperation new];
    operation.persistenceController = self.persistenceController;
    operation.searchID = [Search createWithKeywork:@"Test" inContext:context];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
    
    __weak SearchOperation *weakOperation = operation;
    operation.completionBlock = ^{
        XCTAssertNil(weakOperation.error);
        
        [self validateResultInContext:context];
        
        [expectation fulfill];
    };
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

#pragma mark - Private


@end
