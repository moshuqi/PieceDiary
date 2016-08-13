//
//  PDQuestionInfoCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDQuestionInfoCell.h"

@interface PDQuestionInfoCell ()

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;

@end

@implementation PDQuestionInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.questionLabel.textColor = TitleTextBlackColor;
    self.quantityLabel.textColor = ContentTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithQuestionContent:(NSString *)text quantity:(NSInteger)quantity
{
    self.questionLabel.text = text;
    self.quantityLabel.text = [NSString stringWithFormat:@"%@", @(quantity)];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
