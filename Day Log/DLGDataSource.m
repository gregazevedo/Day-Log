//
//  DLGDataSource.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGDataSource.h"
#import "DLGCoreDataHelper.h"
#import "LogEntry+Helpers.h"
#import "DLGCell.h"

@interface DLGDataSource ()

@end


@implementation DLGDataSource

+(DLGDataSource *)data
{
    static DLGDataSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.logEntries = [[LogEntry allLogs] mutableCopy];
    }
    return self;
}

-(void)insertNewEntryWithDictionary:(NSDictionary *)info
{
    NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    LogEntry *item = [LogEntry insertLogEntryFromDictionary:info];
    [self.logEntries addObject:item];
    [[DLGCoreDataHelper data] saveContext];
}

@end
