//
//  Day+OrderedSet.h
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Day.h"

@interface Day (OrderedSet)

//- (void)insertObject:(Note *)value inNotesAtIndex:(NSUInteger)idx;
//- (void)removeObjectFromNotesAtIndex:(NSUInteger)idx;
//- (void)insertNotes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
//- (void)removeNotesAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectInNotesAtIndex:(NSUInteger)idx withObject:(Note *)value;
//- (void)replaceNotesAtIndexes:(NSIndexSet *)indexes withNotes:(NSArray *)values;
- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSOrderedSet *)values;
- (void)removeNotes:(NSOrderedSet *)values;

@end
