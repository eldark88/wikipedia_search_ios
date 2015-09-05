//
//  SearchOperation.m
//  Wikipedia
//
//  Created by eldark88 on 8/31/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchOperation.h"
#import "PersistenceController.h"
#import "Search.h"
#import "FetchSearchOperation.h"
#import "CacheOperation.h"
#import "Search+Helpers.h"

@interface SearchOperation ()

@property (nonatomic, strong) NSOperationQueue * internalQueue;

@end

@implementation SearchOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.internalQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)main {
    //-- add KVO for isCancelled and make sure that we are not making a strong reference to self
    __weak id weakSelf = self;
    [self addObserver:weakSelf forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:nil];
    
    //-- get a worker context
    NSManagedObjectContext *context = [self.persistenceController createWorkerManagedObjectContext];
    
    //-- get search parameters
    __block NSNumber *offset = nil;
    __block NSString *keyword = nil;
    
    [context performBlockAndWait:^{
        Search *search = (id)[context objectWithID:self.searchID];
        offset = search.count;
        keyword = search.keyword;
    }];
    
    //-- setup a cache operation
    CacheOperation *cacheOperataion = [CacheOperation new];
    cacheOperataion.persistenceController = self.persistenceController;
    cacheOperataion.searchID = self.searchID;
    
    //-- setup a fetch search operation
    FetchSearchOperation *fetchSearchOperation = [FetchSearchOperation new];
    fetchSearchOperation.keyword = keyword;
    fetchSearchOperation.offset = offset;
    fetchSearchOperation.delegate = cacheOperataion;
    
    //-- add operation dependencies
    [cacheOperataion addDependency:fetchSearchOperation];
    
    //-- add operations into queue
    [self.internalQueue addOperation:fetchSearchOperation];
    [self.internalQueue addOperation:cacheOperataion];
    
    //-- wait until all operations are finished
    [self.internalQueue waitUntilAllOperationsAreFinished];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isCancelled"] && [[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
        [self.internalQueue cancelAllOperations];
    }
}

@end
