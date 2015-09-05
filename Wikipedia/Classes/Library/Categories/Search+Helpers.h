//
//  Search+Helpers.h
//  Wikipedia
//
//  Created by eldark88 on 9/4/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "Search.h"

@interface Search (Helpers)

+ (NSManagedObjectID *)findByKeyword:(NSString *)keyword inContext:(NSManagedObjectContext *)context;
+ (NSManagedObjectID *)findOrCreateByKeyword:(NSString *)keyword inContext:(NSManagedObjectContext *)context;
+ (NSManagedObjectID *)createInContext:(NSManagedObjectContext *)context;
+ (NSManagedObjectID *)createWithKeywork:(NSString *)keyword inContext:(NSManagedObjectContext *)context;

@end
