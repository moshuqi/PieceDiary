//
//  PDPieceCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceCell.h"
#import "PDIconsView.h"
#import "PDPhotoData.h"

@interface PDPieceCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *content;

@property (nonatomic, retain) PDIconsView *iconsView;
@property (nonatomic, retain) NSArray<UIImage *> *photos;

@end

@implementation PDPieceCell

- (void)awakeFromNib {
    // Initialization code
    self.content.textColor = ContentTextColor;
}

- (void)setupWithQuestion:(NSString *)question answer:(NSString *)answer photos:(NSArray<UIImage *> *)photos
{
    self.titleLabel.text = question;
    self.content.text = answer;
    self.photos = photos;
    
    [self resetCellColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self resetIconsView];
}

- (void)resetIconsView
{
    // 有图片时显示图片，重新调整布局
    if ([self.photos count] > 0)
    {
        [self showIconsView];
    }
    else
    {
        [self hideIconsView];
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
    [self.iconsView setIconsWithImages:self.photos];
    
    [self.contentView addSubview:self.iconsView];
    
    CGFloat contentOrginX = 20;
    CGFloat h = CGRectGetHeight(self.titleLabel.bounds) + CGRectGetHeight(self.iconsView.bounds);
    CGRect contentFrame = CGRectMake(contentOrginX, h, width - 2 * contentOrginX, height - h);
    
    self.content.frame = contentFrame;
    self.content.contentInset = UIEdgeInsetsMake(kIconsViewHeight, 0, 0, 0);
}

- (void)hideIconsView
{
    [self.iconsView removeFromSuperview];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat contentOrginX = 20;
    CGFloat h = CGRectGetHeight(self.titleLabel.bounds);
    CGRect contentFrame = CGRectMake(contentOrginX, h, width - 2 * contentOrginX, height - h);
    
    self.content.frame = contentFrame;
    self.content.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)resetCellColor
{
    // 根据cell是否编辑过来设置label的颜色
    if ([self hasEdit])
    {
        self.titleLabel.textColor = TitleTextBlackColor;
    }
    else
    {
        self.titleLabel.textColor = TitleTextGrayColor;
    }
}

- (BOOL)hasEdit
{
    // 判断cell是否有编辑过数据
    if ((!self.content.text || [self.content.text length] == 0) &&
        (!self.photos || [self.photos count] == 0))
    {
        return NO;
    }
    
    return YES;
}


@end
