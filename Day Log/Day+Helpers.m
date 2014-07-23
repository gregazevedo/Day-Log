//
//  Day+Helpers.m
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Day+Helpers.h"
#import "DLGCoreDataHelper.h"
#import "Note+Helpers.h"

@implementation Day (Helpers)

+(Day *)today
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.fetchLimit = 1;
    Day *today = [[[DLGCoreDataHelper data].context executeFetchRequest:request error:nil] firstObject];
    if (!today) {
        today = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[DLGCoreDataHelper data].context];
        today.date = [Day todaysDate];
        [Note insertNoteForDay:today andText:@""];
    }
    return today;
}

-(NSString *)title
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:self.date];
}


- (NSComparisonResult)compareDay:(NSDate *)otherDate
{
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [currentCalendar components:dateFlags fromDate:self.date];
    NSDate *selfDateOnly = [currentCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [currentCalendar components:dateFlags fromDate:otherDate];
    NSDate *otherDateOnly = [currentCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}

//today at midnight
+(NSDate *)todaysDate
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
