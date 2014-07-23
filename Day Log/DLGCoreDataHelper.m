//
//  OPNCoreDataHelper.m
//  Open
//
//  Created by Greg Azevedo on 3/2/14.
//  Copyright (c) 2014 dolodev llc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DLGCoreDataHelper.h"

#define DEBUGTHIS 0

@interface DLGCoreDataHelper()

@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStore *store;

@end

@implementation DLGCoreDataHelper


static NSString *modelName = @"DLGModel";
static NSString *storeFilename = @"Day_Log.sqlite";

#pragma mark - SETUP

+ (DLGCoreDataHelper *)data
{
    static DLGCoreDataHelper *sharedInst = nil;
    if (sharedInst == nil) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            sharedInst = [self new];
        });
        [sharedInst setupCoreData];
    }
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    return sharedInst;
}

- (id)init
{
    self = [super init];
    if (self) {
        if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
        NSString *path = [[NSBundle mainBundle] pathForResource:modelName ofType:@"momd"];
        NSURL *momURL = [NSURL fileURLWithPath:path];
        
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:_coordinator];
        [self setupCoreData];
    }
    
    return self;
}

- (void)setupCoreData
{
    [self loadStore];
}

-(void)setupCoreDataForTesting
{
    [self loadInMemoryStore];
}

-(void)loadInMemoryStore
{
    if (!_store) {
        NSError *error = nil;
        _store = [_coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        if (!_store) {
            if(DEBUGTHIS) NSLog(@"Failed to add store. Error: %@", error);abort();
        } else {
            if(DEBUGTHIS) NSLog(@"Successfully added store: %@", _store);
        }
    }
}

-(void)deleteAllObjectsForEntity:(NSString *)entityDescription
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *items = [self.context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) {
    	[self.context deleteObject:managedObject];
    }
    [self saveContext];
}

-(void)deleteAllManagedObjects
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    for (NSString *entityName in [self allEntityNames]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *items = [self.context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *managedObject in items) {
            [self.context deleteObject:managedObject];
        }
    }
    [self saveContext];
}

-(NSArray *)fetchAllManagedObjects
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    NSMutableArray *allItems = [NSMutableArray array];
    
    for (NSString *entityName in [self allEntityNames]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        NSError *error;
        [allItems addObjectsFromArray:[self.context executeFetchRequest:fetchRequest error:&error]];
    }
    return allItems;
}


- (void)loadStore
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));

    if (!_store) {
        NSError *error = nil;
        //updates store if model has been updated, avoid having to delete app
//        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
//                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                            configuration:nil
                                                      URL:[self storeURL]
                                                  options:nil
                                                    error:&error];
        
        if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
        else { NSLog(@"Successfully added store: %@", _store); }
    }
}

#pragma mark - PATHS


- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (NSURL *)applicationStoresDirectory
{
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if (![fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"FAILED to create Stores directory: %@", error);
        }
    }
    return storesDirectory;
}

- (NSURL *)storeURL
{
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:storeFilename];
}

#pragma mark - SAVING

- (void)saveContext
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));

    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            if(DEBUGTHIS) NSLog(@"_context SAVED changes to persistent store");
        } else {
            if(DEBUGTHIS) NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        if(DEBUGTHIS) NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

-(NSArray *)allEntityNames
{
    return [self.model.entitiesByName allKeys];

}

@end
