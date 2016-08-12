//
//  PDWeekdayCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDWeekdayCell.h"

@interface PDWeekdayCell ()

@property (nonatomic, weak) IBOutlet UILabel *weekdayLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;

@end

@implementation PDWeekdayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setupWithWeekday:(NSString *)weekday day:(NSString *)day state:(PDWeekdayCellState)state
{
    self.weekdayLabel.text = weekday;
    self.dayLabel.text = day;
    
    switch (state)
    {
        case PDWeekdayCellStateCurrentDay:
            self.weekdayLabel.textColor = MainBlueColor;
            self.dayLabel.textColor = MainBlueColor;
            break;
            
        default:
            self.weekdayLabel.textColor = TitleTextGrayColor;
            self.dayLabel.textColor = TitleTextGrayColor;
            break;
    }
}

@end
