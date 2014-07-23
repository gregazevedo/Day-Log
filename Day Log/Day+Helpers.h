//
//  Day+Helpers.h
//  Day Log
//
//  Created by Greg Azevedo on 7/23/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "Day.h"

@interface Day (Helpers)

+(NSDate *)todaysDate;
+(Day *)today;

-(NSString *)title;

@end
