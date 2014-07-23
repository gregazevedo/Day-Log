//
//  DLGPresenterTests.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLGTestPreloader.h"
#import "DLGViewController.h"
#import "DLGInteractor.h"

@interface DLGPresenterTests : XCTestCase
{
    DLGPresenter *presenter;
    DLGInteractor *interactor;
    DLGViewController *vc;
}
@end

@implementation DLGPresenterTests

- (void)setUp
{
    [super setUp];
    presenter = [DLGPresenter new];
    interactor = [DLGInteractor new];
    vc = [DLGViewController new];
}

- (void)tearDown
{
    presenter = nil;
    interactor = nil;
    vc = nil;
    [super tearDown];
}

//-(void)testUpdatedUIAfterNewEntry
//{
//    NSInteger entryCount = [vc.collectionView numberOfItemsInSection:0];
//    
//    //view gets touch event for new entry --target action button
//    //view alerts presenter about this
//    [vc.presenter updateToPresentNewEntry];
//    //presenter asks interactor for a blank/default entry
//    [presenter.interactor createNewDefaultEntryForToday];
//    //presenter sends default entry to view
//    [presenter.vc insertNewEntryWithContents:@"default entry text" inSection:0]; //today is section 0, yesterday section 1...
//    //vc updates ui
//    [vc.collectionView reloadData];
//    
//}




- (void)testFoundEntriesToDisplayAfterLaunch
{
    [DLGTestPreloader preloadThisManyEntries:5];
    
    //presenter receives entries from interactor
    
    NSArray *foundEntries = @[];
    
}

- (void)testFoundNoEntriesToDisplay
{
    
}


@end
