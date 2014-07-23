//
//  Note+Helpers.h
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Note.h"

@interface Note (Helpers)

+(Note *)insertNoteWithDate:(NSDate *)date andText:(NSString *)text;
+(NSArray *)allNotesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+(NSArray *)allNotes;
+(NSArray *)allNotes_Max:(NSUInteger)maxFetchCount;
@end
