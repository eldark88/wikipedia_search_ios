//
//  FetchSearchOperationTests.m
//  Wikipedia
//
//  Created by A647700 on 9/5/15.
//  Copyright (c) 2015 A647700. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FetchSearchOperation.h"

@interface FetchSearchOperationTests : XCTestCase <FetchSearchOperation>
@property (nonatomic, copy) void(^delegateBlock)(id object);
@end

@implementation FetchSearchOperationTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOperation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"FetchSearchOperation"];
    
    FetchSearchOperation *operation = [FetchSearchOperation new];
    operation.keyword = @"Test";
    operation.offset = 0;
    operation.delegate = self;
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.delegateBlock = ^(id object){
        XCTAssertNil(operation.error);
        XCTAssertNotEqual(object, nil);
        XCTAssert([object isKindOfClass:NSDictionary.class]);
    };
    
    operation.completionBlock = ^{
        [expectation fulfill];
        
        XCTAssertNil(operation.error);
    };
#pragma clang diagnostic pop
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

#pragma mark - NetworkOperationDelegate
- (void)didReceiveObject:(id)object {
    self.delegateBlock(object);
    
}

- (void)didFailWithError:(NSError *)error {
    self.delegateBlock(error);
}

@end
