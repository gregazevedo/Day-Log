//
//  Note+Helpers.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Note+Helpers.h"
#import "DLGCoreDataHelper.h"
#import "Day+Helpers.h"

@implementation Note (Helpers)

+(NSArray *)fetch:(NSInteger)amount notesWithController:(NSFetchedResultsController *)fetcher
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    [request setFetchBatchSize:amount];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                               managedObjectContext:[DLGCoreDataHelper data].context
                                                                 sectionNameKeyPath:@"date"
                                                                          cacheName:nil];
    fetcher.delegate = self;
    [fetcher.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        if (![fetcher performFetch:&error]) {
            NSLog(@"Failed to perform fetch: %@", error);
        }
    }];
    return fetcher.fetchedObjects;
}


+(NSArray *)allNotes
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSArray *result = [[DLGCoreDataHelper data].context executeFetchRequest:request error:nil];
    return result;
}

+(NSArray *)allNotes_Max:(NSUInteger)maxFetchCount
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.fetchBatchSize = 50;
    NSArray *result = [[DLGCoreDataHelper data].context executeFetchRequest:request error:nil];
    return result;
}

+(NSArray *)allNotesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSArray *result = [[DLGCoreDataHelper data].context executeFetchRequest:request error:nil];
    return result;
}


+(Note *)insertNoteForDay:(Day *)day andText:(NSString *)text
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[DLGCoreDataHelper data].context];
    note.dateCreated = day;
    note.lastEditTime = [NSDate date];
    note.text = text;
    return note;
}
+(Note *)insertNoteWithText:(NSString *)text
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[DLGCoreDataHelper data].context];
    note.lastEditTime = [NSDate date];
    note.text = text;
    return note;
}

@end
