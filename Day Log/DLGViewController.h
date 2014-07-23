//
//  DLGViewController.h
//  Day Log
//
//  Created by Greg Azevedo on 7/21/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLGPresenter.h"
#import "DLGViewModel.h"

@protocol DLGEventHandler <NSObject>
@end


@interface DLGViewController : UIViewController <DLGViewInterface>

@property (nonatomic) DLGPresenter *presenter; //presentaion logic
@property (nonatomic) id <DLGViewModel, DLGLayoutModel> viewModel; //provides the meat


@end
