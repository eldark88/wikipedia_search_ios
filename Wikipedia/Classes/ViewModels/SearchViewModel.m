//
//  SearchViewModel.m
//  Wikipedia
//
//  Created by eldark88 on 9/2/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchOperation.h"
#import "PersistenceController.h"
#import "DetailViewModel.h"
#import "Search+Helpers.h"

static NSString * const wikipediaURL = @"https://en.wikipedia.org/wiki/";

@interface SearchViewModel ()

@property (nonatomic, strong) PersistenceController *persistenceController;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, weak) SearchOperation *searchOperation;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectID *currentSearchID;

@end

@implementation SearchViewModel

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        self.persistenceController = persistenceController;
        self.operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)searchWithKeyword:(NSString *)keyword completionBlock:(void(^)(BOOL completed))completionBlock {
    //-- validate if keyword is not empty
    if (keyword.length==0) {
        completionBlock(NO);
        return;
    }
    
    //-- cancel if another operation is being executed
    if (self.searchOperation.executing) {
        [self cancelSearch];
    }
    
    //-- get a worker context
    NSManagedObjectContext *context = [self.persistenceController createWorkerManagedObjectContext];
    
    //-- find or create a search object
    self.currentSearchID = [Search findOrCreateByKeyword:keyword inContext:context];
    
    //-- update fetchedResultsController predicate
    [self updateSearchProdicationWithKeyword:keyword];
    
    //-- validate if we fetched all the results
    if (![self canContinueSearchInContext:context]) {
         completionBlock(YES);
         return;
    }
    
    //-- setup a search operation
    SearchOperation *searchOperation = [SearchOperation new];
    searchOperation.searchID = self.currentSearchID;
    searchOperation.persistenceController = self.persistenceController;
    
    //-- add to queue
    [self.operationQueue addOperation:searchOperation];
    
    //-- completion handler
    searchOperation.completionBlock = ^{
        completionBlock(NO);
    };
    
    //-- save a weak reference to operation
    self.searchOperation = searchOperation;
}

- (void)fetchSubsequentResultsWithCompletionBlock:(void(^)(BOOL completed))completionBlock {
    //-- check if another operation is being executed and validate currentSearchID.
    //-- We don't need to cancel operation here, just return
    if (self.searchOperation.executing || !self.currentSearchID) {
        completionBlock(NO);
        return;
    }
    
    //-- create a worker context
    NSManagedObjectContext *context = [self.persistenceController createWorkerManagedObjectContext];
    
    //-- validate if we fetched all the results
    if (![self canContinueSearchInContext:context]) {
        completionBlock(YES);
        return;
    }
    
    //-- setup a search operation
    SearchOperation *searchOperation = [SearchOperation new];
    searchOperation.searchID = self.currentSearchID;
    searchOperation.persistenceController = self.persistenceController;
    
    //-- add to queue
    [self.operationQueue addOperation:searchOperation];
    
    //-- completion handler
    searchOperation.completionBlock = ^{
        completionBlock(NO);
    };
    
    //-- save a weak reference to operation
    self.searchOperation = searchOperation;
}

- (void)updateSearchProdicationWithKeyword:(NSString *)keyword {
    //-- update the fetch predicate
    self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"search.keyword==[cd]%@", keyword];
    
    //TODO: need to handler an error
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"error = %@", error);
    }
}

- (BOOL)canContinueSearchInContext:(NSManagedObjectContext *)context {
    __block BOOL canContinue = YES;
    
    [context performBlockAndWait:^{
        if (self.currentSearchID) {
            Search *search = (id)[context objectWithID:self.currentSearchID];
            canContinue = ![search isCompleted];
        }
    }];
    
    return canContinue;
}

- (void)cancelSearch {
    //-- set completion block for all operations to nil
    for (NSOperation *operation in self.operationQueue.operations) {
        operation.completionBlock = nil;
    }
    
    //-- cancel all operations
    [self.operationQueue cancelAllOperations];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchResult" inManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:self.persistenceController.managedObjectContext
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:nil];
    
    self.fetchedResultsController = theFetchedResultsController;
    
    return _fetchedResultsController;
}

- (DetailViewModel *)detailViewModelWithWithTitle:(NSString *)title {
    if (title.length==0) {
        return nil;
    }
    
    NSURL *url = [self urlWithTitle:title];
    
    return [[DetailViewModel alloc] initWithTitle:title url:url];
}

- (NSString *)formattedDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM dd, YYYY";
    return [formatter stringFromDate:date];
}

- (NSURL *)urlWithTitle:(NSString *)title {
    NSString *encodedTitle = [[title stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", wikipediaURL, encodedTitle];
    
    return [NSURL URLWithString:urlString];
}

@end
