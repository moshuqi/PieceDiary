//
//  NSDate+PDDate.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "NSDate+PDDate.h"

@implementation NSDate (PDDate)

- (NSInteger)yearValue
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger year = components.year;
    return year;
}

- (NSInteger)monthValue
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger month = components.month;
    return month;
}

- (NSInteger)dayValue
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger day = components.day;
    return day;
}

- (NSInteger)weekdayValue
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
    
    NSInteger weekday = components.weekday;
    return weekday;
}

- (NSDate *)beforeDays:(NSInteger)days
{
    // 前几天
    return [self intervalDays:-days];
}

- (NSDate *)afterDays:(NSInteger)days
{
    // 后几天
    return [self intervalDays:days];
}

- (NSDate *)intervalDays:(NSInteger)days
{
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] + (24 * 3600 * days))];
    return newDate;
}

- (NSDate *)getSundayInThisWeek
{
    // 获取本周的周日，第一天。
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
    NSInteger weekday = components.weekday;
    
    NSDate *newDate = [self beforeDays:(weekday - 1)];
    return newDate;
}

@end
