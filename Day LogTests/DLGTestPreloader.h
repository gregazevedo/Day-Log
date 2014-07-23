//
//  DLGTestPreloader.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LogEntry;

@interface DLGTestPreloader : NSObject

+(NSArray *)preloadThisManyEntries:(NSInteger)entryCount;
+(LogEntry *)preloadEntry;

@end
