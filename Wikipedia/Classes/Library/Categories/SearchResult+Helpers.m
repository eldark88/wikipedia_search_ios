//
//  SearchResult+Helpers.m
//  Wikipedia
//
//  Created by eldark88 on 9/4/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchResult+Helpers.h"

@implementation SearchResult (Helpers)

+ (instancetype)createInContext:(NSManagedObjectContext *)context {
	return [NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:context];
}

@end
