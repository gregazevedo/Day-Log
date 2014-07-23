//
//  NSDate+Utility.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

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
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSInteger curDay = [currentCalendar  ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:[NSDate date]];
    NSInteger curYear = [currentCalendar  ordinalityOfUnit:NSYearCalendarUnit inUnit:NSEraCalendarUnit forDate:[NSDate date]];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:curYear];
    [dateComponents setDay:curDay];
    NSDate *today = [currentCalendar dateFromComponents:dateComponents];
    NSLog(@"today is: %f",[today timeIntervalSince1970]);
    return today;
}

@end
