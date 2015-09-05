//
//  PersistenceController.h
//  Wikipedia
//
//  Created by eldark88 on 8/31/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PersistenceController : NSObject

- (instancetype)initWithStoreType:(NSString *)storeType;

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

- (NSManagedObjectContext *)createWorkerManagedObjectContext;
- (void)save;

@end
