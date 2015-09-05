//
//  SearchResult.h
//  Wikipedia
//
//  Created by eldark88 on 9/1/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface SearchResult : NSManagedObject

@property (nonatomic, retain) NSDate * lastEditedDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Search *search;

@end
