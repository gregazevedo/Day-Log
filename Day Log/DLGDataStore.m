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

@interface DLGDataStore () <NSFetchedResultsControllerDelegate>

//@property (nonatomic) NSMutableArray *loadedNotes;
@property (nonatomic) NSMutableArray *loadedDays;
@property (nonatomic) NSFetchedResultsController *fetchController;
@end


@implementation DLGDataStore

#pragma mark - VIEW MODEL METHODS -

#pragma mark FETCH

//laucnh
//fetch last day
//if its not today, insert today with 1 note

-(void)fetchNotesForToday
{
    Day *today = [Day today];
    self.loadedDays = [@[today] mutableCopy];
}

-(void)fetchNotesForDay:(NSDate *)day
{
    
}

-(void)fetchOneMoreWeekOfNotes
{
    
}

//-(void)loadLatestNotes
//{
//    self.loadedNotes = [[Note allNotes_Max:50] mutableCopy];
//    if (self.loadedNotes.count == 0) {
//        [self insertTutorialNote];
//    }
//}

//-(void)loadMoreNotes_Amount:(NSInteger)amount
//{
////    self.fetchController = [Note prepareFetchController]
////    self.loadedNotes = [Note fetch:amount notesWithController:self.fetchController];
//}

-(NSUInteger)numberOfSections
{
    return self.loadedDays.count;
    
//    return self.fetchController.sections.count;
}

-(NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    Day *day = [self.loadedDays objectAtIndex:section];
    return [day.notes count];
    
//    if (self.fetchController.sections.count > 0) {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
//        return [sectionInfo numberOfObjects];
//    }
//    return 0;
//    return self.loadedNotes.count;
}

-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:[indexPath section]];
    Note *note = [day.notes objectAtIndex:[indexPath row]];
    return note.text;
    
//    Note *note = [self.fetchController objectAtIndexPath:indexPath];
//    return note.text;
//    Note *note = [self.loadedNotes objectAtIndex:indexPath.row];
//    return note.text;
}

-(NSString *)titleForHeaderInSection:(NSUInteger)section
{
    Day *day = [self.loadedDays objectAtIndex:section];
    return [day title];
    
    
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
//    return [sectionInfo name];
}

-(NSIndexPath *)lastIndex
{
    NSUInteger section = [self numberOfSections]-1;
    NSUInteger row = [self numberOfItemsInSection:section]-1;
    return [NSIndexPath indexPathForItem:row inSection:section];
    
    
//    if (self.loadedNotes.count == 0) {
//        return nil;
//    }
//    if (self.loadedNotes.count == 1) {
//        return [NSIndexPath indexPathForItem:0 inSection:0];
//    }
//    return [NSIndexPath indexPathForItem:self.loadedNotes.count-1 inSection:0];
}

#pragma mark  INSERTING

//-(void)insertTutorialNote
//{
//    Note *note = [Note insertNoteWithDate:[NSDate date] andText:@"Welcome to Day Log, leave your first note in a log"];
//    Note *blankNote = [Note insertNoteWithDate:[NSDate date] andText:@""];
//    [self.loadedNotes addObjectsFromArray:@[note, blankNote]];
//}

-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *note = [Note insertNoteWithText:@""];
    [day addNotesObject:note];
    
//    [day insertObject:note inNotesAtIndex:indexPath.row];
//    [day addNotesObject:note];
    
    
//    Note *note = [Note insertNoteWithDate:[NSDate date] andText:@""];
//    [self.loadedNotes insertObject:note atIndex:indexPath.row];
}

#pragma mark UPDATING

-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *noteToUpdate = [day.notes objectAtIndex:indexPath.row];
    [noteToUpdate setText:contents];
    
    
//    Note *note = [self.loadedNotes objectAtIndex:indexPath.row];
//    [note setText:contents];
}

#pragma mark REMOVING

-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *noteToRemove = [day.notes objectAtIndex:indexPath.row];
    [day removeNotesObject:noteToRemove];
//    [day removeNotesObject:noteToRemove];
//    [day removeObjectFromNotesAtIndex:indexPath.row];
    
    
//    [self.loadedNotes removeObjectAtIndex:indexPath.row];
}

-(void)saveChanges
{
    [[DLGCoreDataHelper data] saveContext];
}

#pragma mark - LAYOUT MODEL METHODS -

-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath
{
    Day *day = [self.loadedDays objectAtIndex:indexPath.section];
    Note *noteToSize = [day.notes objectAtIndex:indexPath.row];
    CGSize cellSize = [noteToSize.text boundingRectWithSize:CGSizeMake(300, 900) options:0 attributes:nil context:nil].size;
    return CGSizeMake(300, cellSize.height+50);

    
//    Note *note = [self.loadedNotes objectAtIndex:indexPath.row];
//    CGSize cellSize = [note.text boundingRectWithSize:CGSizeMake(300, 900) options:0 attributes:nil context:nil].size;
//    return CGSizeMake(300, cellSize.height+50);
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
