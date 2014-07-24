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
}

- (void)tearDown
{
    [super tearDown];
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
    NSInteger previousCount = dataStore.today.notes.count;
    [vc selectItemAtIndexPath:[dataStore lastIndex]];
    [vc selectItemAtIndexPath:[vc nextIndexPath]];
    
    NSInteger updatedCount = dataStore.today.notes.count;
    XCTAssertTrue(updatedCount == previousCount-1, @"should have removed 1 note, prev: %i now: %i", previousCount, updatedCount);
    
    Day *todayFromArray = [dataStore.loadedDays firstObject];
    Day *today = dataStore.today;
    XCTAssertEqualObjects(today, todayFromArray, @"these should be the same after an insert");
    XCTAssertTrue([todayFromArray.notes isEqualToOrderedSet:today.notes], @"same");

}

@end