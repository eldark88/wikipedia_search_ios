//
//  SearchViewModel.h
//  Wikipedia
//
//  Created by eldark88 on 9/2/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersistenceController, DetailViewModel;

@interface SearchViewModel : NSObject

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController;

- (void)searchWithKeyword:(NSString *)keyword completionBlock:(void(^)(BOOL completed))completionBlock;
- (void)fetchSubsequentResultsWithCompletionBlock:(void(^)(BOOL completed))completionBlock;
- (void)cancelSearch;

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

- (NSString *)formattedDate:(NSDate *)date;
- (DetailViewModel *)detailViewModelWithWithTitle:(NSString *)title;

@end
