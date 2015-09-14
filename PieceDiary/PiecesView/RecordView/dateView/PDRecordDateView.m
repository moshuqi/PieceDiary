//
//  PDRecordDateView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordDateView.h"

@interface PDRecordDateView ()

@property (nonatomic, retain) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) IBOutlet UIImageView *dateImageView;

@end

@implementation PDRecordDateView

- (IBAction)touchedDateButton:(id)sender
{
    [self.delegate enterSettingDateView];
}

@end
