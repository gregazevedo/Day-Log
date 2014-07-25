//
//  DLGInsertTests.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLGDataStore.h"
#import "DLGViewModel.h"
#import "DLGViewController.h"
#import "DLGRouter.h"
#import "DLGAppDelegate.h"
#import "Note+Helpers.h"
#import "Day+Helpers.h"
#import "Day+OrderedSet.h"


@interface DLGInsertTests : XCTestCase
{
    DLGRouter *router;
    DLGDataStore *dataStore;
    DLGViewController *vc;
    DLGAppDelegate *app;
    NSInteger initalNoteCount;
}
@end

@implementation DLGInsertTests

- (void)setUp
{
    [super setUp];
    
    app = (DLGAppDelegate *)[[UIApplication sharedApplication] delegate];
    router = app.router;
    dataStore = router.dataStore;
    vc = router.viewController;
    initalNoteCount = [self currentNoteCount];
    XCTAssertTrue(initalNoteCount > 0, @"app should start with at least 1 note");
}

- (void)tearDown
{
    while ([self currentNoteCount] > initalNoteCount) {
        NSInteger cur = [self currentNoteCount];
        [dataStore removeEntryAtIndexPath:dataStore.lastIndex];
        XCTAssertTrue([self currentNoteCount] == cur-1, @"should be 1 less per loop, initial: %i, cur: %i", initalNoteCount, [self currentNoteCount]);
    }
    XCTAssertTrue([self currentNoteCount] == initalNoteCount, @"test should end with same count as start, initial: %i, cur: %i", initalNoteCount, [self currentNoteCount]);

    [super tearDown];
}

-(NSInteger)currentNoteCount
{
    NSInteger count = 0;
    for (NSInteger section = 0; section < dataStore.numberOfSections; section++) {
        count += dataStore.numberOfSections * [dataStore numberOfItemsInSection:section];
    }
    return count;
}

-(void)testNewNote
{
    XCTAssertNotNil(dataStore, @"not nil");
    NSInteger previousCount = dataStore.today.notes.count;
    [dataStore insertNewEntryAtIndexPath:[dataStore lastIndex]];
    NSInteger updatedCount = dataStore.today.notes.count;
    XCTAssertTrue(updatedCount == previousCount+1, @"should have inserted 1 more note");
    
    XCTAssertTrue([[dataStore.loadedDays firstObject] isKindOfClass:[Day class]], @"loadedDays should have Days");
    Day *todayFromArray = [dataStore.loadedDays firstObject];
    Day *today = dataStore.today;
    XCTAssertEqualObjects(today, todayFromArray, @"these should be the same after an insert");
    XCTAssertTrue([todayFromArray.notes isEqualToOrderedSet:today.notes], @"same");
}

-(void)testRemovingNewNote
{
    NSInteger initalCount = dataStore.today.notes.count;
    
    [vc selectItemAtIndexPath:[dataStore lastIndex]];
    [vc selectItemAtIndexPath:[vc nextIndexPath]];
    NSInteger countByGoingToNext = dataStore.today.notes.count;
    if ([[dataStore contentsForIndexPath:[vc selectedIndexPath]] isEqualToString:@""]) {
        XCTAssertTrue(countByGoingToNext == initalCount, @"going to next note from empty last should NOT create new note, prev: %i now: %i", initalCount, countByGoingToNext);
        XCTAssertNil([vc selectedIndexPath], @"next from empty cell should deselect index: %@", [vc selectedIndexPath]);
    } else {
        XCTAssertTrue(countByGoingToNext == initalCount+1, @"going to next note from last should creat new note, prev: %i now: %i", initalCount, countByGoingToNext);
    }

    [vc selectItemAtIndexPath:[vc previousIndexPath]];
    NSInteger countByGoingToPrevious = dataStore.today.notes.count;
    XCTAssertTrue(countByGoingToPrevious == initalCount, @"should have removed 1 note, prev: %i now: %i", initalCount, countByGoingToPrevious);
    
    Day *todayFromArray = [dataStore.loadedDays firstObject];
    Day *today = dataStore.today;
    XCTAssertEqualObjects(today, todayFromArray, @"these should be the same after an insert");
    XCTAssertTrue([todayFromArray.notes isEqualToOrderedSet:today.notes], @"same");

}

@end