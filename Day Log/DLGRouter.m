//
//  DLGRouter.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGRouter.h"

@interface DLGRouter ()

@end

@implementation DLGRouter

-(DLGRouter *)initWithWindow:(UIWindow *)window
{
    if (self = [super init]) {
        self.dataStore = [DLGDataStore new];
        self.viewController = [DLGViewController new];
        self.eventHandler = [DLGEventHandler new];
        self.viewController.viewModel = self.dataStore;
        self.viewController.eventHandler = self.eventHandler;
        self.navigationController = [[DLGNavigationController alloc]initWithRootViewController:self.viewController];
        window.rootViewController = self.navigationController;
    }
    return self;
}

@end
