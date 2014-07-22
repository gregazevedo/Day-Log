//
//  LogItem+Helpers.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "LogItem.h"

@interface LogItem (Helpers)

+(LogItem *)insertLogItemFromDictionary:(NSDictionary *)itemInfo;
+(NSArray *)allLogs;

-(NSString *)timeString;
-(NSString *)durationString;

@end
