//
//  DLGDataStore.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGDataStore.h"
#import "LogEntry.h"
#import "Note.h"
#import "LogEntry+Helpers.h"
#import "DLGCoreDataHelper.h"

@interface DLGDataStore ()


@end


@implementation DLGDataStore

#pragma mark - VIEWMODEL METHODS

-(void)loadLogEntries
{
    self.logEntries = [[LogEntry allLogs] mutableCopy];
    if (self.logEntries.count == 0) {
        [self insertTutorialLog];
    }
}

-(void)insertTutorialLog
{
    LogEntry *entry = [LogEntry insertLogEntryFromDictionary:@{@"startDate": [NSDate date], @"endDate":[NSDate date], @"note":@"Welcome to Day Log, please leave your first note!"}];
    [self.logEntries addObject:entry];
}

-(NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    return self.logEntries.count;
}

-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath
{
    LogEntry *entry = [self.logEntries objectAtIndex:indexPath.row];
    return entry.note.contents;
}

-(NSIndexPath *)lastIndex
{
    return [NSIndexPath indexPathForItem:self.logEntries.count-1 inSection:0];
}

-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents
{
    LogEntry *entry = [self.logEntries objectAtIndex:indexPath.row];
    [entry.note setContents:contents];
}

-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath
{
    LogEntry *entry = [LogEntry insertLogEntryFromDictionary:@{@"startDate": [NSDate date], @"endDate":[NSDate date], @"note":@""}];
    [self.logEntries insertObject:entry atIndex:indexPath.row];
}

-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath
{
    [self.logEntries removeObjectAtIndex:indexPath.row];
}

-(void)saveChanges
{
    [[DLGCoreDataHelper data] saveContext];
}

#pragma mark - LAYOUT MODEL METHODS


-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath
{
    LogEntry *entry = [self.logEntries objectAtIndex:indexPath.row];
    CGSize cellSize = [entry.note.contents boundingRectWithSize:CGSizeMake(300, 900) options:0 attributes:nil context:nil].size;
    return CGSizeMake(300, cellSize.height+50);
}

-(CGSize)averageItemSize
{
    return CGSizeMake(300, 60);
}


#pragma mark - INTERACTOR METHODS

-(LogEntry *)insertNewDefaultEntryForToday
{
    LogEntry *entry = [LogEntry insertLogEntryFromDictionary:@{@"startDate": [NSDate date], @"endDate":[NSDate date], @"note":@""}];
    [self.logEntries addObject:entry];
    return entry;
}

-(void)removeEntry:(LogEntry *)entry
{
    
}

@end
