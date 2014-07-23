//
//  NSDate+Utility.h
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (NSComparisonResult)compareDay:(NSDate *)otherDate;

+(NSDate *)today;

@end
