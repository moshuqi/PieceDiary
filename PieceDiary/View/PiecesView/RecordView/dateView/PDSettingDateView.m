//
//  PDSettingDateView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDSettingDateView.h"
#import "PDDefine.h"
#import "NSDate+PDDate.h"

@interface PDSettingDateView ()

@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *doneBtn;
@property (nonatomic, weak) IBOutlet UIButton *todayBtn;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation PDSettingDateView

- (void)awakeFromNib
{
    [self.cancelBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
    [self.todayBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
    
    self.dateLabel.textColor = TitleTextBlackColor;
    self.dateLabel.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = BackgroudGrayColor;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate dateSettingCancel];
}

- (IBAction)done:(id)sender
{
    
}

- (IBAction)setToday:(id)sender
{
    
}

- (void)setupWithDate:(NSDate *)date
{
    NSInteger year = [date yearValue];
    NSInteger month = [date monthValue];
    NSInteger day = [date dayValue];
    
    NSString *text = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, month, day];
    self.dateLabel.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
