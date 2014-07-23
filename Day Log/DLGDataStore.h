//
//  DLGDataStore.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLGViewModel.h"

@class LogEntry;

@interface DLGDataStore : NSObject <DLGViewModel, DLGLayoutModel>

@property (nonatomic) NSMutableArray *logEntries;

-(LogEntry *)insertNewDefaultEntryForToday;
-(void)removeEntry:(LogEntry *)entry;

@end
