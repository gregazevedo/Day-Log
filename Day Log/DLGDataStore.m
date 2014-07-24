//
//  DLGDataStore.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGDataStore.h"
#import "Note+Helpers.h"
#import "Day+Helpers.h"
#import "Day+OrderedSet.h"
#import "DLGCoreDataHelper.h"

@interface DLGDataStore ()

@end


@implementation DLGDataStore

#pragma mark - VIEW MODEL METHODS -

#pragma mark FETCH

-(void)fetchNotesForToday
{
    self.today = [Day today];
    self.loadedDays = [@[self.today] mutableCopy];
}

#pragma mark - DATA SOURCE

-(NSUInteger)numberOfSections
{
    return self.loadedDays.count;
}

-(NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    Day *day = [self.loadedDays objectAtIndex:section];
    return [day.notes count];
}

-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *note = [day.notes objectAtIndex:indexPath.row];
    return note.text;
}

-(NSString *)titleForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    return [day title];
}

-(NSIndexPath *)lastIndex
{
    NSUInteger section = [self numberOfSections]-1;
    NSUInteger row = [self numberOfItemsInSection:section]-1;
    return [NSIndexPath indexPathForItem:row inSection:section];
}

#pragma mark  INSERTING

-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    NSLog(@"notes before: %i", day.notes.count);
    if ([day isEqual:self.today]) {
        Note *note = [Note insertNoteWithText:@""];
        [day addNotesObject:note];
    } else {
        NSLog(@"cant add note for any day but today");
    }
    NSLog(@"notes after: %i", day.notes.count);
}

#pragma mark UPDATING

-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *noteToUpdate = [day.notes objectAtIndex:indexPath.row];
    [noteToUpdate setText:contents];
}

-(void)saveChanges
{
    [[DLGCoreDataHelper data] saveContext];
}

#pragma mark REMOVING

-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *noteToRemove = [day.notes objectAtIndex:indexPath.row];
    [day removeNotesObject:noteToRemove];
}

#pragma mark - LAYOUT MODEL METHODS -

-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *noteToSize = [day.notes objectAtIndex:indexPath.row];
    CGSize cellSize = [noteToSize.text boundingRectWithSize:CGSizeMake(300, 900) options:0 attributes:nil context:nil].size;
    return CGSizeMake(300, cellSize.height+50);
}

-(CGSize)averageItemSize
{
    return CGSizeMake(300, 60);
}

-(CGSize)headerSize
{
    return CGSizeMake(300, 60);
}

@end
