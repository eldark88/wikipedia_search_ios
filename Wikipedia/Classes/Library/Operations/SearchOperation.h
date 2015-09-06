//
//  SearchOperation.h
//  Wikipedia
//
//  Created by eldark88 on 8/31/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersistenceController;

@interface SearchOperation : NSOperation

@property (nonatomic, strong) NSManagedObjectID *searchID;
@property (nonatomic, strong) PersistenceController * persistenceController;
@property (nonatomic, strong, readonly) NSError *error;

@end
