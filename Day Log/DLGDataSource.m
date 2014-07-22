//
//  DLGDataSource.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGDataSource.h"
#import "DLGCoreDataHelper.h"
#import "LogItem+Helpers.h"

#import "DLGTableViewCell.h"

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
        self.logEntries = [[LogItem allLogs] mutableCopy];
    }
    return self;
}

-(void)insertNewEntryWithDictionary:(NSDictionary *)info
{
    NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    LogItem *item = [LogItem insertLogItemFromDictionary:info];
    [self.logEntries addObject:item];
    [[DLGCoreDataHelper data] saveContext];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    LogItem *item = [self.logEntries objectAtIndex:indexPath.row];
    [cell configureForLogItem:item];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logEntries.count;
}

@end
