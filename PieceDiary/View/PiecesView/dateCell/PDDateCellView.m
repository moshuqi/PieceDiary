//
//  PDDateCellView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/9.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDDateCellView.h"
#import "PDDefine.h"
#import "PDDataManager.h"

@interface PDDateCellView ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;   // 显示“日”
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;  // 显示日期，不包括“日”
@property (nonatomic, weak) IBOutlet UIImageView *weatherIcon;    // 显示天气图标
@property (nonatomic, weak) IBOutlet UIImageView *moodIcon;   //  显示心情图标

@property (nonatomic, retain) PDDateCellDataModel *dataModel;

@end

@implementation PDDateCellView

- (void)setupDateCellWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger weekDay = components.weekday;
    
    [self setDayLabelWithDay:day];
    [self setDateLabelWithYear:year month:month weekDay:weekDay];
    
    PDDataManager *dataManager = [PDDataManager defaultManager];
    UIImage *weatherImage = [dataManager getWeatherImageWithDate:date];
    UIImage *moodImage = [dataManager getMoodImageWithDate:date];
    
    self.weatherIcon.image = weatherImage;
    self.moodIcon.image = moodImage;
}

- (void)awakeFromNib
{
    self.dayLabel.textColor = TitleTextBlackColor;
    self.dateLabel.textColor = TitleTextBlackColor;
}

- (void)setDayLabelWithDay:(NSInteger)day
{
    // 设置“日”
    
    if (day < 1 || day > 31)
    {
        PDLog(@"日期超出合理范围.");
        return;
    }
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
}

- (void)setDateLabelWithYear:(NSInteger)year month:(NSInteger)month weekDay:(NSInteger)weekDay
{
    if (weekDay < 1 || weekDay > 7)
    {
        PDLog(@"星期超出合理范围.");
        return;
    }
    
    NSArray *weekDayArray = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSString *weekDayStr = weekDayArray[weekDay - 1];
    NSString *yearMonStr = [NSString stringWithFormat:@"%ld年%ld月", year, month];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", weekDayStr, yearMonStr];
    self.dateLabel.text = text;
}

- (void)setWeatherIconWithImage:(UIImage *)image
{
    self.weatherIcon.image = image;
}

- (void)setMoodIconWithImage:(UIImage *)image
{
    self.moodIcon.image = image;
}

- (void)setupWithDataModel:(PDDateCellDataModel *)dataModel
{
    self.dataModel = dataModel;
    
    [self setupDateCellWithDate:dataModel.date];
    self.weatherIcon.image = dataModel.weatherIcon;
    self.moodIcon.image = dataModel.moodIcon;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
