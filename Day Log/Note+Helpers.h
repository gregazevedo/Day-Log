//
//  Note+Helpers.h
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Note.h"

@interface Note (Helpers)

+(Note *)insertNoteForDay:(Day *)day andText:(NSString *)text;
+(Note *)insertNoteWithText:(NSString *)text;

+(NSArray *)allNotesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+(NSArray *)allNotes;
+(NSArray *)allNotes_Max:(NSUInteger)maxFetchCount;
+(NSArray *)fetch:(NSInteger)amount notesWithController:(NSFetchedResultsController *)fetcher;

@end
