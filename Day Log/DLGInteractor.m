//
//  DLGInteractor.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGInteractor.h"
#import "LogEntry.h"
#import "Note.h"

@implementation DLGInteractor

//-(NSArray *)findAllLogEntries
//{
//    return [LogEntry allLogs];
//}

-(NSString *)createNewDefaultEntryForToday
{
    LogEntry *entry = [self.dataStore insertNewDefaultEntryForToday];    
    return entry.note.contents;
}

@end
