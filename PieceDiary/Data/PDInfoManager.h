//
//  PDInfoManager.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDInfoManager : NSObject

+ (instancetype)defaultManager;
- (NSArray *)getDiaryInfoData;
- (NSArray *)getGridInfoData;

+ (NSInteger)getYearValueWithDate:(NSDate *)date;
+ (NSInteger)getMonthValueWithDate:(NSDate *)date;
+ (NSInteger)getWeekdayValueWithDate:(NSDate *)date;
+ (NSInteger)getDayValueWithDate:(NSDate *)date;

@end
