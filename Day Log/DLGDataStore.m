//
//  DLGDataStore.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGDataStore.h"
#import "Note+Helpers.h"
#import "DLGCoreDataHelper.h"

@interface DLGDataStore ()

@property (nonatomic) NSMutableArray *loadedNotes;

@end


@implementation DLGDataStore

#pragma mark - VIEW MODEL METHODS -

#pragma mark FETCH

-(void)loadLatestNotes
{
    self.loadedNotes = [[Note allNotes_Max:50] mutableCopy];
    if (self.loadedNotes.count == 0) {
        [self insertTutorialNote];
    }
}

-(void)loadMoreNotes_Amount:(NSInteger)amount
{
    
}

-(NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    return self.loadedNotes.count;
}

-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.loadedNotes objectAtIndex:indexPath.row];
    return note.text;
}

-(NSIndexPath *)lastIndex
{
    if (self.loadedNotes.count == 0) {
        return nil;
    }
    if (self.loadedNotes.count == 1) {
        return [NSIndexPath indexPathForItem:0 inSection:0];
    }
    return [NSIndexPath indexPathForItem:self.loadedNotes.count-1 inSection:0];
}

#pragma mark  INSERTING

-(void)insertTutorialNote
{
    Note *note = [Note insertNoteWithDate:[NSDate date] andText:@"Welcome to Day Log, leave your first note in a log"];
    Note *blankNote = [Note insertNoteWithDate:[NSDate date] andText:@""];
    [self.loadedNotes addObjectsFromArray:@[note, blankNote]];
}

-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [Note insertNoteWithDate:[NSDate date] andText:@""];
    [self.loadedNotes insertObject:note atIndex:indexPath.row];
}

#pragma mark UPDATING

-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents
{
    Note *note = [self.loadedNotes objectAtIndex:indexPath.row];
    [note setText:contents];
}

#pragma mark REMOVING

-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath
{
    [self.loadedNotes removeObjectAtIndex:indexPath.row];
}

-(void)saveChanges
{
    [[DLGCoreDataHelper data] saveContext];
}

#pragma mark - LAYOUT MODEL METHODS -

-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.loadedNotes objectAtIndex:indexPath.row];
    CGSize cellSize = [note.text boundingRectWithSize:CGSizeMake(300, 900) options:0 attributes:nil context:nil].size;
    return CGSizeMake(300, cellSize.height+50);
}

-(CGSize)averageItemSize
{
    return CGSizeMake(300, 60);
}

@end
