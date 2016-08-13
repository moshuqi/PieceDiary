//
//  PDQuestionDetailCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDQuestionDetailCell.h"

@interface PDQuestionDetailCell ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *weekdayLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photo;


@end

@implementation PDQuestionDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    // 临时处理。
    CGFloat photoW = 88 - 20 * 2;
    self.photo.clipsToBounds = YES;
    self.photo.layer.cornerRadius = photoW / 2;
    self.photo.layer.borderWidth = 1;
    self.photo.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithDay:(NSInteger)day weekday:(NSInteger)weekday answer:(NSString *)answer photo:(UIImage *)photo
{
    self.dayLabel.text = [NSString stringWithFormat:@"%@", @(day)];
    
    NSArray *weekdayArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.weekdayLabel.text = [NSString stringWithFormat:@"周%@", weekdayArray[weekday - 1]];
    
    // 没有答案时显示“无内容”，并把字体颜色改为灰色
    if (answer && [answer length] > 0)
    {
        self.answerLabel.text = answer;
        self.answerLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.answerLabel.text = @"无内容";
        self.answerLabel.textColor = [UIColor lightGrayColor];
    }
    
    if (photo)
    {
        self.photo.image = photo;
        self.photo.hidden = NO;
    }
    else
    {
        self.photo.hidden = YES;
    }
    
}


@end
