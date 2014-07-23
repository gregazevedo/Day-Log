//
//  Note+Helpers.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Note+Helpers.h"
#import "DLGCoreDataHelper.h"

@implementation Note (Helpers)


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


+(Note *)insertNoteWithDate:(NSDate *)date andText:(NSString *)text
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[DLGCoreDataHelper data].context];
    note.text = text;
    note.date = date;
    return note;
}

@end
