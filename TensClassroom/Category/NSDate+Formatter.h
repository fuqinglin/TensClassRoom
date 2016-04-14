//
//  NSDate+Formatter.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/30.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)

- (NSString *)formatToString;

+ (NSDate *)dateFromTimestamp:(int64_t)timestamp;

@end
