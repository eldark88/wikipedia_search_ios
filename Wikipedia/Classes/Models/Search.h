//
//  Search.h
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SearchResult;

@interface Search : NSManagedObject

- (BOOL)isCompleted;

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSSet *results;
@end

@interface Search (CoreDataGeneratedAccessors)

- (void)addResultsObject:(SearchResult *)value;
- (void)removeResultsObject:(SearchResult *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

@end
