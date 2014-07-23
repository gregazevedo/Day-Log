//
//  DLGViewModel.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGViewModel <NSObject>

-(void)loadLogEntries;
-(NSUInteger)numberOfItemsInSection:(NSUInteger)section;
-(NSString *)contentsForIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)lastIndex;
-(void)updateContentsForIndexPath:(NSIndexPath *)indexPath withContents:(NSString *)contents;
-(void)insertNewEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void)removeEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void)saveChanges;

@end


@protocol DLGLayoutModel <NSObject>

-(CGSize)sizeForIndexPath:(NSIndexPath *)indexPath;
-(CGSize)averageItemSize;

//-(CGSize)itemSize;
//-(CGSize)titleSize;
//-(CGSize)responseSize;
//-(CGSize)totalQuestionSize;

@end

