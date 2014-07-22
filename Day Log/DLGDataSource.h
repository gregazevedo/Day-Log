//
//  DLGDataSource.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLGDataSource : NSObject <UITableViewDataSource>

+(DLGDataSource *)data;

-(void)insertNewEntryWithDictionary:(NSDictionary *)info;

@property (nonatomic) NSMutableArray *logEntries;

@end
