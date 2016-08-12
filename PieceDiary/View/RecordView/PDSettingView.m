//
//  PDSettingView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/11.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDSettingView.h"
#import "PDRecordDateView.h"
#import "PDRecordWeather.h"
#import "PDRecordMood.h"
#import "PDSettingDateView.h"
#import "PDDataManager.h"

@interface PDSettingView () <PDRecordDateViewDelegate, PDSettingDateViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *dateView;
@property (nonatomic, weak) IBOutlet UIView *weatherView;
@property (nonatomic, weak) IBOutlet UIView *moodView;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) PDRecordDateView *recordDateView;
@property (nonatomic, retain) PDRecordWeather *weather;
@property (nonatomic, retain) PDRecordMood *mood;

@property (nonatomic, retain) PDSettingDateView *settingDateView;
@property (nonatomic, retain) NSDate *date;

@end

@implementation PDSettingView

- (void)awakeFromNib
{
    // Initialization code

    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDRecordDateView" owner:self.recordDateView options:nil];
    self.recordDateView = [nibViews firstObject];
    self.recordDateView.delegate = self;
    
    [self.dateView addSubview:self.recordDateView];
    self.recordDateView.frame = self.dateView.bounds;
    
    self.weather = [[PDRecordWeather alloc] init];
    self.weather.iconView.frame = self.weatherView.bounds;
    [self.weatherView addSubview:self.weather.iconView];
    
    self.mood = [[PDRecordMood alloc] init];
    self.mood.iconView.frame = self.moodView.bounds;
    [self.moodView addSubview:self.mood.iconView];
    
    [self.doneButton setTitleColor:TitleTextBlackColor forState:UIControlStateNormal];
    self.doneButton.backgroundColor = BackgroudGrayColor;
}

- (void)setupSettingViewWithDate:(NSDate *)date
{
    self.date = date;
    [self.recordDateView setDateStringWithDate:date];
    
    PDDataManager *dataManager = [PDDataManager defaultManager];
    NSString *weather = [dataManager getWeahterStringWithDate:date];
    NSString *mood = [dataManager getMoodStringWithDate:date];
    
    [self.weather setSelectedWithString:weather];
    [self.mood setSelectedWithString:mood];
}

- (IBAction)toucheDone:(id)sender
{
    [self.delegate settingDone:sender];
}

- (NSString *)getWeatherSettingString
{
    return [self.weather getSettingString];
}

- (NSString *)getMoodSettingString
{
    return [self.mood getSettingString];
}

- (void)showSettingDateView
{
    // 日期设置界面弹出显示
    CGRect fromRect = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGRect toRect = self.bounds;
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDSettingDateView" owner:self options:nil];
    self.settingDateView = [nibViews firstObject];
    
    self.settingDateView.delegate = self;
    [self.settingDateView setupWithDate:self.date];
    self.settingDateView.frame = fromRect;
    [self addSubview:self.settingDateView];
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.settingDateView.frame = toRect;
    } completion:nil];
}

- (void)hideSettingDateView
{
    // 日期设置界面滑出消失
    CGRect toRect = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.settingDateView.frame = toRect;
    } completion:^(BOOL finished){
        [self.settingDateView removeFromSuperview];
        self.settingDateView = nil;
    }];
}

#pragma mark - PDRecordDateViewDelegate

- (void)enterSettingDateView
{
    [self showSettingDateView];
}

#pragma mark - PDSettingDateViewDelegate

- (void)dateSettingCancel
{
    [self hideSettingDateView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
