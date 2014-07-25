//
//  DLGCellSelectionTests.m
//  Day Log
//
//  Created by Greg Azevedo on 7/24/14.
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

@interface DLGCellSelectionTests : XCTestCase
{
    DLGRouter *router;
    DLGDataStore *dataStore;
    DLGViewController *vc;
    DLGAppDelegate *app;
}

@end

@implementation DLGCellSelectionTests

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

//-(void)testDeselectWorks
//{
////    NSIndexPath *initial = [vc selectedIndexPath];
////    XCTAssertEqualObjects(initial, dataStore.lastIndex, @"last index should be initally selected, %@, %@", initial, dataStore.lastIndex);
//    
//    
//    [vc selectItemAtIndexPath:[vc nextIndexPath]];
//    [vc selectItemAtIndexPath:[vc nextIndexPath]];
//    XCTAssertNil([vc selectedIndexPath], @"going to next twice should deselect");
//    
//    [vc selectItemAtIndexPath:[vc previousIndexPath]];
//    XCTAssertNil([vc selectedIndexPath], @"there should be no selection to go to previous");
//
//
//}

@end
