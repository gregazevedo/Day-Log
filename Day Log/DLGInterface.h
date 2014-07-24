//
//  DLGInterface.h
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLGInterface <NSObject>

-(void)selectItemAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) NSIndexPath *nextIndexPath;
@property (nonatomic, readonly) NSIndexPath *previousIndexPath;

@end
