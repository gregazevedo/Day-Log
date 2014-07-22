//
//  LogItem.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface LogItem : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * dayOfWeek;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) Note *note;

@end
