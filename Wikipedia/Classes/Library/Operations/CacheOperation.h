//
//  CacheOperation.h
//  Wikipedia
//
//  Created by eldark88 on 8/31/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FetchSearchOperation.h"

@class PersistenceController;

@interface CacheOperation : AsyncOperation <NetworkOperationDelegate>

@property (nonatomic, strong) PersistenceController *persistenceController;
@property (nonatomic, strong) NSManagedObjectID *searchID;

@end
