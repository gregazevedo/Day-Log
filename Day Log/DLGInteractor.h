//
//  DLGInteractor.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLGDataStore.h"

@interface DLGInteractor : NSObject

@property (nonatomic) DLGDataStore *dataStore;

//-(NSArray *)findAllLogEntries;
-(NSString *)createNewDefaultEntryForToday;

@end
