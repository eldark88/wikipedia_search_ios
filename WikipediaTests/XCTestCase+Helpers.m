//
//  XCTestCase+Helpers.m
//  Wikipedia
//
//  Created by A647700 on 9/6/15.
//  Copyright (c) 2015 A647700. All rights reserved.
//

#import "XCTestCase+Helpers.h"
#import <CoreData/CoreData.h>
#import "SearchResult.h"
#import "PersistenceController.h"

@implementation XCTestCase (Helpers)

- (PersistenceController *)createTestPersistenceController {
    return [[PersistenceController alloc] initWithStoreType:NSInMemoryStoreType];
}

- (void)validateResultInContext:(NSManagedObjectContext *)context {
    [context performBlockAndWait:^{
        
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchResult" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        
        XCTAssertNil(error);
        XCTAssert([result[0] isKindOfClass:SearchResult.class]);
        
    }];
}

@end
