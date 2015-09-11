//
//  PDPieceCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceCell.h"
#import "PDIconsView.h"

#define kIconsViewHeight    56

@interface PDPieceCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, retain) PDIconsView *iconsView;


@end

@implementation PDPieceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 有图片时显示图片，重新调整布局
    if ([self.icons count] > 0)
    {
        [self showIconsView];
    }
}

- (void)showIconsView
{
    if (!self.iconsView)
    {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDIconsView" owner:self options:nil];
        self.iconsView = [nibViews objectAtIndex:0];
    }
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGRect iconsViewFrame = CGRectMake(0, CGRectGetHeight(self.titleLabel.bounds), width, kIconsViewHeight);
    self.iconsView.frame = iconsViewFrame;
    [self.iconsView setIconsWithImages:self.icons];
    
    [self.contentView addSubview:self.iconsView];
    
    CGFloat h = CGRectGetHeight(self.titleLabel.bounds) + CGRectGetHeight(self.iconsView.bounds);
    CGRect contentLabelFrame = CGRectMake(0, h, width, height - h);
    self.contentLabel.frame = contentLabelFrame;
}

@end
