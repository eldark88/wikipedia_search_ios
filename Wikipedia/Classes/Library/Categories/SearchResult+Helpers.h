//
//  SearchResult+Helpers.h
//  Wikipedia
//
//  Created by eldark88 on 9/4/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchResult.h"

@interface SearchResult (Helpers)

+ (instancetype)createInContext:(NSManagedObjectContext *)context;

@end
