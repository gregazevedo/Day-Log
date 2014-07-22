//
//  OPNCoreDataHelper.h
//  Open
//
//  Created by Greg Azevedo on 3/2/14.
//  Copyright (c) 2014 dolodev llc. All rights reserved.
//


@interface DLGCoreDataHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

+ (DLGCoreDataHelper *)data;
- (void)setupCoreData;
- (void)saveContext;
-(void)setupCoreDataForTesting;
-(void)deleteAllObjectsForEntity:(NSString *)entityDescription;
-(NSArray *)allEntityNames;

@end
