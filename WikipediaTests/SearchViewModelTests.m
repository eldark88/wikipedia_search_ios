//
//  SearchViewModelTests.m
//  Wikipedia
//
//  Created by A647700 on 9/6/15.
//  Copyright (c) 2015 A647700. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchViewModel.h"
#import "PersistenceController.h"
#import "XCTestCase+Helpers.h"
#import "DetailViewModel.h"

@interface SearchViewModelTests : XCTestCase

@property (nonatomic, strong) PersistenceController *persistenceController;
@property (nonatomic, strong) SearchViewModel *viewModel;

@end

@implementation SearchViewModelTests

- (void)setUp {
    [super setUp];
    
    self.persistenceController = [self createTestPersistenceController];
    
    self.viewModel = [[SearchViewModel alloc] initWithPersistenceController:self.persistenceController];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSearch {
    XCTestExpectation *searchExpectation = [self expectationWithDescription:@"Search"];
    
    [self.viewModel searchWithKeyword:@"Test" completionBlock:^(BOOL completed) {
        NSManagedObjectContext *context = [self.persistenceController createWorkerManagedObjectContext];
        
        [self validateResultInContext:context];
        
        [searchExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
    
    XCTestExpectation *subsequentSearchExpectation = [self expectationWithDescription:@"Search Subsequent Result"];
    
    [self.viewModel fetchSubsequentResultsWithCompletionBlock:^(BOOL completed) {
        NSManagedObjectContext *context = [self.persistenceController managedObjectContext];
        
        [self validateResultInContext:context];
        
        [subsequentSearchExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void)testDetailViewModel {
    NSString *title = @"Test test";
    DetailViewModel *detailViewModel = [self.viewModel detailViewModelWithWithTitle:title];
    
    XCTAssertEqual(title, detailViewModel.title);
    XCTAssertEqualObjects(detailViewModel.url.absoluteString, @"https://en.wikipedia.org/wiki/Test_test");
}

@end
