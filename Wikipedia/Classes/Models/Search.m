//
//  Search.m
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "Search.h"

@implementation Search

@dynamic count;
@dynamic date;
@dynamic keyword;
@dynamic total;
@dynamic results;

- (BOOL)isCompleted {
    return self.count.integerValue>=self.total.integerValue && self.total.integerValue!=0;
}

@end
