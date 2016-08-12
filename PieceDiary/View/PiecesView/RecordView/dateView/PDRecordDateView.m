//
//  PDRecordDateView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordDateView.h"
#import "NSDate+PDDate.h"
#import "PDDefine.h"

@interface PDRecordDateView ()

@property (nonatomic, retain) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) IBOutlet UIImageView *dateImageView;

@end

@implementation PDRecordDateView

- (void)awakeFromNib
{
    [self.dateButton setTitleColor:TitleTextBlackColor forState:UIControlStateNormal];
}

- (IBAction)touchedDateButton:(id)sender
{
    [self.delegate enterSettingDateView];
}

- (void)setDateStringWithDate:(NSDate *)date
{
    NSInteger year = [date yearValue];
    NSInteger month = [date monthValue];
    NSInteger day = [date dayValue];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, month, day];
    [self.dateButton setTitle:dateStr forState:UIControlStateNormal];
    [self.dateButton setTitle:dateStr forState:UIControlStateHighlighted];
}

@end
