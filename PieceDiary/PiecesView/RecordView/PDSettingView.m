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

@interface PDSettingView ()

@property (nonatomic, weak) IBOutlet PDRecordDateView *dateView;
@property (nonatomic, weak) IBOutlet UIView *weatherView;
@property (nonatomic, weak) IBOutlet UIView *moodView;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) PDRecordDateView *recordDateView;
@property (nonatomic, retain) PDRecordWeather *weather;
@property (nonatomic, retain) PDRecordMood *mood;

@end

@implementation PDSettingView

- (void)awakeFromNib
{
    // Initialization code
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDRecordDateView" owner:self options:nil];
    self.recordDateView = [nibViews firstObject];
    [self.dateView addSubview:self.recordDateView];
    self.recordDateView.frame = self.dateView.bounds;
    
    self.weather = [[PDRecordWeather alloc] init];
    self.weather.iconView.frame = self.weatherView.bounds;
    [self.weatherView addSubview:self.weather.iconView];
    
    self.mood = [[PDRecordMood alloc] init];
    self.mood.iconView.frame = self.moodView.bounds;
    [self.moodView addSubview:self.mood.iconView];
}

- (IBAction)toucheDone:(id)sender
{
    [self.delegate settingDone:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
