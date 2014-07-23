//
//  DLGPresenter.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DLGViewModel.h"

@class DLGInteractor;


@protocol DLGViewInterface <NSObject>

-(void)insertNewEntryWithContents:(NSString *)contents atIndexPath:(NSIndexPath *)indexPath;

@end


@interface DLGPresenter : NSObject 

@property (nonatomic) DLGInteractor *interactor;
@property (nonatomic) id <DLGViewInterface> interface;

-(void)updateToPresentNewEntry;

@end
