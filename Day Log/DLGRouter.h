//
//  DLGRouter.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLGNavigationController.h"
#import "DLGViewController.h"
#import "DLGDataStore.h"
#import "DLGEventHandler.h"

@interface DLGRouter : NSObject

-(DLGRouter *)initWithWindow:(UIWindow *)window;
@property (nonatomic) DLGNavigationController *navigationController;
@property (nonatomic) DLGViewController *viewController;
@property (nonatomic) DLGDataStore *dataStore;
@property (nonatomic) DLGEventHandler *eventHandler;

@end
