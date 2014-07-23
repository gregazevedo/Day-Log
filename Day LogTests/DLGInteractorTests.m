//
//  DLGInteractorTests.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLGInteractor.h"
#import "LogEntry+Helpers.h"
#import "Note.h"
#import "DLGCoreDataHelper.h"
#import "DLGTestPreloader.h"

@interface DLGInteractorTests : XCTestCase
{
    DLGInteractor *interactor;
    DLGCoreDataHelper *coreDataHelper;
}
@end

@implementation DLGInteractorTests

- (void)setUp
{
    [super setUp];
    interactor = [DLGInteractor new];
    coreDataHelper = [DLGCoreDataHelper new];
    XCTAssertTrue([coreDataHelper fetchAllManagedObjects].count == 0, @"these tests assume a fresh database");
}

- (void)tearDown
{
    [coreDataHelper deleteAllManagedObjects];
    interactor = nil;
    coreDataHelper = nil;
    [super tearDown];
}

//-(void)testFindingAllLogEntries
//{
//    NSArray *logEntries = [interactor findAllLogEntries];
//    XCTAssertTrue(logEntries.count == 0 || [[logEntries firstObject] isKindOfClass:[LogEntry class]], @"log entries should be LogEntrys not %@", [[logEntries firstObject] class]);
//}

-(void)testSavingNewLogEntry
{
    LogEntry *entry = [LogEntry insertLogEntryFromDictionary:@{@"startDate": [NSDate date], @"endDate":[NSDate date], @"note":@"yada yada yada"}];
    XCTAssertNotNil(entry, @"entry should exist");
    XCTAssertNotNil(entry.startDate, @"entry should exist");
    XCTAssertNotNil(entry.endDate, @"entry should exist");
    XCTAssertNotNil(entry.note, @"entry should exist");
    XCTAssertNotNil(entry.note.contents, @"entry should exist");
}

//-(void)testUpdatingExistingLogEntry
//{
//    [DLGTestPreloader preloadEntry];
//    
//    //mock fetch
//    NSArray *logEntries = [interactor findAllLogEntries];
//    LogEntry *entryToUpdate = [logEntries firstObject];
//    NSString *update = @" an update to the note yada yada";
//    entryToUpdate.note.contents = [entryToUpdate.note.contents stringByAppendingString:update];
//    [coreDataHelper saveContext];
//    
//    //check if updated
//    LogEntry *fetchedUpdate = [[interactor findAllLogEntries] firstObject];
//    XCTAssertTrue([fetchedUpdate.note.contents hasSuffix:update], @"newly fetched should show updates, string is: %@", fetchedUpdate.note.contents);
//}



@end