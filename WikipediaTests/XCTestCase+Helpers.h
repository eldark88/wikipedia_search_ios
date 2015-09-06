//
//  XCTestCase+Helpers.h
//  Wikipedia
//
//  Created by A647700 on 9/6/15.
//  Copyright (c) 2015 A647700. All rights reserved.
//

#import <XCTest/XCTest.h>

@class NSManagedObjectContext, PersistenceController;

@interface XCTestCase (Helpers)

- (PersistenceController *)createTestPersistenceController;
- (void)validateResultInContext:(NSManagedObjectContext *)context;

@end
