//
//  Note.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogItem;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) LogItem *item;

@end
