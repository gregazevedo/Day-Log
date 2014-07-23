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

#import "DLGPresenter.h"
#import "DLGInteractor.h"
#import "DLGDataStore.h"


#import "DLGTestPreloader.h"

@interface DLGRouter ()

@property (nonatomic) DLGNavigationController *navigationController;
@property (nonatomic) DLGViewController *viewController;
@property (nonatomic) DLGPresenter *presenter;
@property (nonatomic) DLGInteractor *interactor;
@property (nonatomic) DLGDataStore *dataStore;

@end

@implementation DLGRouter

-(DLGRouter *)initWithWindow:(UIWindow *)window
{
    if (self = [super init]) {
        self.dataStore = [DLGDataStore new];
        self.interactor = [DLGInteractor new];
        self.presenter = [DLGPresenter new];
        self.viewController = [DLGViewController new];
        
//        self.dataStore.logEntries = [DLGTestPreloader preloadThisManyEntries:10];
        
        self.interactor.dataStore = self.dataStore;
        
        self.presenter.interactor = self.interactor;
        self.presenter.interface = self.viewController;
        
        self.viewController.viewModel = self.dataStore;
        self.viewController.presenter = self.presenter;
        
        self.navigationController = [[DLGNavigationController alloc]initWithRootViewController:self.viewController];
        
        window.rootViewController = self.navigationController;
    }
    return self;
}

@end
