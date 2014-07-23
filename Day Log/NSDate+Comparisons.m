//
//  NSDate+Comparisons.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "NSDate+Comparisons.h"

@implementation NSDate (Comparisons)

- (NSComparisonResult)compareDay:(NSDate *)otherDate
{
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [currentCalendar components:dateFlags fromDate:self];
    NSDate *selfDateOnly = [currentCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [currentCalendar components:dateFlags fromDate:otherDate];
    NSDate *otherDateOnly = [currentCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}

//today at midnight
+(NSDate *)today
{
    NSDate *date = [NSDate date];
    //set
    return date;
}

@end
