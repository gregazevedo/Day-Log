//
//  DLGLayout.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLGViewModel.h"

@interface DLGLayout : UICollectionViewLayout

-(DLGLayout *)initWithDataSource:(id<DLGLayoutModel>)dataSource;
-(void)transitionToEditCellLayout;
-(void)transitionToBrowsingLayout;

@end

