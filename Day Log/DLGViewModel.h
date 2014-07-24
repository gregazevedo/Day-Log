//
//  DLGViewModel.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGLayoutModel <NSObject>

-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath;
-(CGSize)averageItemSize;
-(CGSize)headerSize;
-(CGFloat)lineHeight;

@end


@protocol DLGViewModel <DLGLayoutModel>

-(void)fetchNotesForToday;
-(void)fetchNotesForDay:(NSDate *)day;
-(void)fetchOneMoreWeekOfNotes;

-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents;
-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void)saveChanges;

-(NSUInteger)numberOfItemsInSection:(NSUInteger)section;
-(NSUInteger)numberOfSections;
-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath;
-(NSString *)titleForHeaderAtIndexPath:(NSIndexPath *)indexPath;

-(NSIndexPath *)lastIndex;

@end


