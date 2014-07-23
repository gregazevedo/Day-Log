//
//  DLGPresenter.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGPresenter.h"
#import "DLGInteractor.h"

@interface DLGPresenter ()


@end


@implementation DLGPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interactor = [DLGInteractor new];
    }
    return self;
}

-(void)updateToPresentNewEntry
{
    NSString *contents = [self.interactor createNewDefaultEntryForToday];
    NSIndexPath *firstIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.interface insertNewEntryWithContents:contents atIndexPath:firstIndex]; //today is section 0, yesterday section 1...
}



@end
