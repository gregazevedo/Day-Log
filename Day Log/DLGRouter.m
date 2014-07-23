//
//  DLGRouter.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGRouter.h"
#import "DLGNavigationController.h"
#import "DLGViewController.h"
#import "DLGDataStore.h"

@interface DLGRouter ()

@property (nonatomic) DLGNavigationController *navigationController;
@property (nonatomic) DLGViewController *viewController;
@property (nonatomic) DLGDataStore *dataStore;

@end

@implementation DLGRouter

-(DLGRouter *)initWithWindow:(UIWindow *)window
{
    if (self = [super init]) {
        self.dataStore = [DLGDataStore new];
        self.viewController = [DLGViewController new];
        self.viewController.viewModel = self.dataStore;
        self.navigationController = [[DLGNavigationController alloc]initWithRootViewController:self.viewController];
        window.rootViewController = self.navigationController;
    }
    return self;
}

@end
