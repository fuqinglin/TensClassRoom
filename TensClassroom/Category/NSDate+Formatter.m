//
//  NSDate+Formatter.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/30.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

- (NSString *)formatToString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromTimestamp:(int64_t)timestamp
{
    NSTimeInterval interval = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    return [currentDate dateByAddingTimeInterval:interval];
}

@end
