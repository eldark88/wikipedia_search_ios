//
//  CacheOperation.m
//  Wikipedia
//
//  Created by eldark88 on 8/31/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "CacheOperation.h"
#import "AsyncOperation+Private.h"
#import "PersistenceController.h"
#import "SearchResult+Helpers.h"
#import "Search.h"

@interface CacheOperation ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSError *error;

@end

@implementation CacheOperation

- (void)main {
    if (![self validate]) {
        
        //-- finish execution
        self.executing = NO;
        self.finished = YES;
        
        return;
    }
    
    //-- add KVO for isCancelled and make sure that we are not making a strong reference to self
    __weak id weakSelf = self;
    [self addObserver:weakSelf forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:nil];
    
    //-- get a worker context
    self.managedObjectContext = [self.persistenceController createWorkerManagedObjectContext];
    
    //-- perform import
    [self.managedObjectContext performBlockAndWait:^{
        [self import];
    }];
    
    //-- save all the changes
    [self.managedObjectContext performBlock:^{
        [self.managedObjectContext save:nil];
    }];
    
    //-- finish execution
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - Validation
- (BOOL)validate {
    if (!self.error && [self.object isKindOfClass:NSDictionary.class]) {
        return YES;
    }
    return NO;
}

#pragma mark - Import
- (void)import {
    //-- get search
    Search *search = (id)[self.managedObjectContext objectWithID:self.searchID];

    //-- get search result
    NSArray *searchResult = [self searchResult];
    
    //-- get search order
    NSInteger order = search.count.integerValue;
    
    //-- save each result
    for (NSDictionary *result in searchResult) {
        NSString *title = [result valueForKey:@"title"];
        NSString *timestamp = [result valueForKey:@"timestamp"];
        NSDate *lastEditedDate = [self dateFromString:timestamp];
        order = order + 1;
        
        [self importSearchResultWithSearch:search title:title lastEditedDate:lastEditedDate order:@(order)];
    }
    
    //-- update count and total number of records
    search.count = @(search.count.integerValue + searchResult.count);
    search.total = self.totalResult;
}

- (void)importSearchResultWithSearch:(Search *)search title:(NSString *)title lastEditedDate:(NSDate *)lastEditedDate order:(NSNumber *)order {
    //-- create a new SearchResult
    SearchResult *searchResult = [SearchResult createInContext:self.managedObjectContext];
    
    //-- update fields
    searchResult.search = search;
    searchResult.title = title;
    searchResult.lastEditedDate = lastEditedDate;
    searchResult.order = order;
}

#pragma mark - Helpers
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormatter dateFromString:string];
}

- (NSArray *)searchResult {
    return [self.object valueForKeyPath:@"query.search"];
}

- (NSNumber *)totalResult {
    return [self.object valueForKeyPath:@"query.searchinfo.totalhits"];
}

#pragma mark - NetworkOperationDelegate
- (void)didReceiveObject:(id)object {
    self.object = object;
}

- (void)didFailWithError:(NSError *)error {
    self.error = error;
}

#pragma mark - KVO Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isCancelled"] && [[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
        //-- rollback any changes when operation is cancelled
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext rollback];
        }];
        
        //-- update flags
        self.executing = NO;
        self.finished = YES;
    }
}

@end
