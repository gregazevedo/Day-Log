//
//  DLGViewController.h
//  Day Log
//
//  Created by Greg Azevedo on 7/21/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLGViewModel.h"

@interface DLGViewController : UIViewController

@property (nonatomic) id <DLGViewModel, DLGLayoutModel> viewModel;

@end
