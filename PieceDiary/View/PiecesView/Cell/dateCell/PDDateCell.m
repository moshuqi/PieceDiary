//
//  PDDateCell.m
//  PieceDiary
//
//  Created by HD on 16/8/12.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDateCell.h"

@interface PDDateCell ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;   // 显示“日”
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;  // 显示日期，不包括“日”
@property (nonatomic, weak) IBOutlet UIImageView *weatherIcon;    // 显示天气图标
@property (nonatomic, weak) IBOutlet UIImageView *moodIcon;   //  显示心情图标

@end

@implementation PDDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.dayLabel.textColor = TitleTextBlackColor;
    self.dateLabel.textColor = TitleTextBlackColor;
}

- (void)setupWithDate:(NSDate *)date weatherIcon:(UIImage *)weatherIcon moodIcon:(UIImage *)moodIcon
{
    NSInteger year = date.yearValue;
    NSInteger month = date.monthValue;
    NSInteger day = date.dayValue;
    NSInteger weekday = date.weekdayValue;
    
    NSArray *weekDayArray = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSString *weekDayStr = weekDayArray[weekday - 1];
    NSString *yearMonStr = [NSString stringWithFormat:@"%@年%@月", @(year), @(month)];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", weekDayStr, yearMonStr];
    self.dateLabel.text = text;
    self.dayLabel.text = [NSString stringWithFormat:@"%@", @(day)];
    
    self.weatherIcon.image = weatherIcon;
    self.moodIcon.image = moodIcon;
}

@end
