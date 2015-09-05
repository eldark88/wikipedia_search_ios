//
//  PersistenceController.m
//  Wikipedia
//
//  Created by eldark88 on 8/31/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "PersistenceController.h"

@interface PersistenceController ()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) NSString *storeType;

@end

@implementation PersistenceController

- (instancetype)initWithStoreType:(NSString *)storeType {
    self = [super init];
    if (self) {
        self.storeType = storeType;
        
        [self initializeCoreData];
    }
    return self;
}

- (id)init {
	self = [super init];
	if (self) {
        self.storeType = NSSQLiteStoreType;
        
		[self initializeCoreData];
	}

	return self;
}

- (void)initializeCoreData {
	if (self.managedObjectContext) {
		return;
	}

    //-- setup NSManagedObjectModel
	NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];

    //-- setup NSPersistentStoreCoordinator
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

    //-- setup main NSManagedObjectContext
	self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    //-- setup private NSManagedObjectContext
	self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	self.privateContext.persistentStoreCoordinator = coordinator;

	self.managedObjectContext.parentContext = self.privateContext;
    
    //-- add persistent store
	NSMutableDictionary *options = [NSMutableDictionary dictionary];
	options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
	options[NSInferMappingModelAutomaticallyOption] = @YES;

    //TODO: handle error and run this operation in background thread
	NSError *error = nil;
	if ([coordinator addPersistentStoreWithType:self.storeType configuration:nil URL:self.storeURL options:options error:&error]) {

	}
}

- (NSManagedObjectContext *)createWorkerManagedObjectContext {
	NSManagedObjectContext *workerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	workerManagedObjectContext.parentContext = self.managedObjectContext;

	return workerManagedObjectContext;
}

- (void)save {
    //-- if no changes, then just return
	if (!self.privateContext.hasChanges && !self.managedObjectContext.hasChanges) {
		return;
	}
    
    //-- save changes in main and private context
	[[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        [self.managedObjectContext save:&error];

        [[self privateContext] performBlock:^{
            NSError *privateError = nil;
            [self.privateContext save:&privateError];
        }];
	 }];
}

#pragma mark - Helpers
- (NSURL *)storeURL {
    NSURL *cachesFolder = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    return [cachesFolder URLByAppendingPathComponent:@"search.sqlite"];
}

- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"search" withExtension:@"momd"];
}

@end
