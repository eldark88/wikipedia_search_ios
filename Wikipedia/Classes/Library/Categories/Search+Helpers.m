//
//  Search+Helpers.m
//  Wikipedia
//
//  Created by eldark88 on 9/4/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "Search+Helpers.h"
#import "SearchResult.h"

@implementation Search (Helpers)

+ (NSManagedObjectID *)findByKeyword:(NSString *)keyword inContext:(NSManagedObjectContext *)context {
	__block NSManagedObjectID *objectID = nil;

    [context performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Search"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"keyword==[cd]%@", keyword];

        NSArray *result = [context executeFetchRequest:fetchRequest error:nil];

        if (result.count>0) {
            objectID = [result[0] objectID];
        }
    }];

	return objectID;
}

+ (NSManagedObjectID *)findOrCreateByKeyword:(NSString *)keyword inContext:(NSManagedObjectContext *)context {
    NSManagedObjectID *objectID = [self findByKeyword:keyword inContext:context];

    if (objectID) {
        return objectID;
    }
    else {
        return [self createWithKeywork:keyword inContext:context];
    }
}

+ (NSManagedObjectID *)createInContext:(NSManagedObjectContext *)context {
    __block NSManagedObjectID *objectID = nil;

    [context performBlockAndWait:^{
        Search *search = [NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:context];
        search.date = [NSDate date];
        objectID = search.objectID;

        [context save:nil];
    }];

	return objectID;
}

+ (NSManagedObjectID *)createWithKeywork:(NSString *)keyword inContext:(NSManagedObjectContext *)context {
    __block NSManagedObjectID *objectID = nil;

    [context performBlockAndWait:^{
        Search *search = [NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:context];
        search.keyword = keyword;
        search.date = [NSDate date];
        objectID = search.objectID;

        [context save:nil];
    }];

	return objectID;
}

@end
