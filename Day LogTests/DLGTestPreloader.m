//
//  DLGTestPreloader.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGTestPreloader.h"
#import "LogEntry+Helpers.h"
#import "DLGCoreDataHelper.h"

@implementation DLGTestPreloader

+(LogEntry *)preloadEntry
{
    LogEntry *entry = [LogEntry insertLogEntryFromDictionary:@{@"startDate": [NSDate date], @"endDate":[NSDate date], @"note":@"yada yada yada"}];
    [[DLGCoreDataHelper data] saveContext];
    return entry;
}

+(NSArray *)preloadThisManyEntries:(NSInteger)entryCount
{
    NSMutableArray *entries = [NSMutableArray array];
    for (NSInteger i = 0; i < entryCount; i++) {
        [entries addObject:[LogEntry insertLogEntryFromDictionary:@{@"startDate": [NSDate date], @"endDate":[NSDate date], @"note":@"yada yada yada"}]];
    }
    return entries;
}

@end
