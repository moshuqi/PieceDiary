//
//  PDTimeFunc.m
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDTimeFunc.h"

@implementation PDTimeFunc

+ (NSDate *)dateFromString:(NSString *)dateString
{
    // 将string转换成date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    // 将date转换成string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

@end
