//
//  LogEntry+Helpers.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "LogEntry+Helpers.h"
#import "Note.h"

#import "DLGCoreDataHelper.h"

@implementation LogEntry (Helpers)

+(NSArray *)allLogs
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LogEntry"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    NSArray *result = [[DLGCoreDataHelper data].context executeFetchRequest:request error:nil];
    return result;
}


+(LogEntry *)insertLogEntryFromDictionary:(NSDictionary *)itemInfo
{
    LogEntry *item = [NSEntityDescription insertNewObjectForEntityForName:@"LogEntry" inManagedObjectContext:[DLGCoreDataHelper data].context];
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[DLGCoreDataHelper data].context];
    item.startDate = [itemInfo objectForKey:@"startDate"];
    item.endDate = [itemInfo objectForKey:@"endDate"];
    item.duration = [itemInfo objectForKey:@"duration"];
    
    note.contents = [itemInfo objectForKey:@"note"];
    item.note = note;
    
    return item;
}

-(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *start = [dateFormatter stringFromDate:self.startDate];
    NSString *end = [dateFormatter stringFromDate:self.endDate];
    return [NSString stringWithFormat:@"%@ to %@", start, end];
}

-(NSString *)durationString
{
    NSTimeInterval start = [self.startDate timeIntervalSince1970];
    NSTimeInterval end = [self.endDate timeIntervalSince1970];
    NSInteger duration = (end - start)/60/60;
    return [NSString stringWithFormat:@"%i hours",duration];
}

//convenince but messy
//+(LogEntry *)insertNewDefaultEntryForToday
//{
//    LogEntry *item = [NSEntityDescription insertNewObjectForEntityForName:@"LogEntry" inManagedObjectContext:[DLGCoreDataHelper data].context];
//    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[DLGCoreDataHelper data].context];
//    item.startDate = [NSDate date];
//    item.endDate = [NSDate date];
//    item.duration = @0;
//    item.note = note;
//    item.note.contents = @"";
//    return item;
//}



@end
