//
//  PDSettingDateView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDSettingDateView.h"

@interface PDSettingDateView ()

@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *doneBtn;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation PDSettingDateView

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
