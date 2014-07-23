//
//  DLGViewModel.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGViewModel <NSObject>

-(void)fetchNotesForToday;
-(void)fetchNotesForDay:(NSDate *)day;
-(void)fetchOneMoreWeekOfNotes;

//-(void)loadLatestNotes;
//-(void)loadMoreNotes_Amount:(NSInteger)amount;

-(NSUInteger)numberOfItemsInSection:(NSUInteger)section;
-(NSUInteger)numberOfSections;

-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath;

-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents;
-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void)saveChanges;

-(NSIndexPath *)lastIndex;

@end


@protocol DLGLayoutModel <NSObject>

-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath;
-(CGSize)averageItemSize;
-(CGSize)headerSize;

//-(CGSize)itemSize;
//-(CGSize)titleSize;
//-(CGSize)responseSize;
//-(CGSize)totalQuestionSize;

@end

