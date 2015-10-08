//
//  PDGridCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/16.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDGridCell.h"
#import "PDDefine.h"

@interface PDGridCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;

@end

@implementation PDGridCell

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLabel.textColor = TitleTextBlackColor;
    self.quantityLabel.textColor = ContentTextColor;
}

- (void)setCellTitleWithText:(NSString *)text;
{
    self.titleLabel.text = text;
}

- (void)setQuantityWithNumber:(NSInteger)number
{
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", number];
}

@end
