//
//  Day+OrderedSet.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Day+OrderedSet.h"

@implementation Day (OrderedSet)

static NSString *const kNotesKey = @"notes";


- (void)addNotesObject:(Note *)note
{
    if ([self.notes containsObject:note]) {
        return;
    }
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:self.notes.count];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:kNotesKey];
    [[self primitiveValueForKey:kNotesKey] addObject:note];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:kNotesKey];
}

- (void)removeNotesObject:(Note *)note
{
    if (![self.notes containsObject:note]) {
        return;
    }
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.notes indexOfObject:note]];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:kNotesKey];
    [[self primitiveValueForKey:kNotesKey] removeObject:note];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:kNotesKey];
}

- (void)addNotes:(NSOrderedSet *)notes
{
    if ([notes isSubsetOfOrderedSet:self.notes]) {
        return;
    }
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.notes.count, notes.count)];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:kNotesKey];
    [[self primitiveValueForKey:kNotesKey] unionOrderedSet:notes];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:kNotesKey];
}

- (void)removeNotes:(NSOrderedSet *)notes
{
    if (![self.notes intersectsOrderedSet:notes]) {
        return;
    }
    NSIndexSet * indexSet = [self.notes indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [notes containsObject:obj];
    }];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:kNotesKey];
    [[self primitiveValueForKey:kNotesKey] minusOrderedSet:notes];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:kNotesKey];
}

@end
