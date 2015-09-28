//
//  PDPieceCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceCell.h"
#import "PDIconsView.h"
#import "PDPhotoDataModel.h"

@interface PDPieceCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *content;
@property (nonatomic, retain) PDPieceCellDataModel *dataModel;

@property (nonatomic, retain) PDIconsView *iconsView;


@end

@implementation PDPieceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self resetIconsView];
}

- (void)resetIconsView
{
    // 有图片时显示图片，重新调整布局
    if ([self.icons count] > 0)
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
    [self.iconsView setIconsWithImages:self.icons];
    
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

- (void)setupWithDataModel:(PDPieceCellDataModel *)dataModel
{
    self.dataModel = dataModel;
    
    self.titleLabel.text = dataModel.question;
    self.content.text = dataModel.answer;
    
    NSArray *photoDataModels = dataModel.photoDataModels;
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger i = 0; i < [photoDataModels count]; i++)
    {
        PDPhotoDataModel *model = photoDataModels[i];
        [photos addObject:model.image];
    }
    self.icons = photos;
    
//    [self resetIconsView];
    [self resetCellColor];
}

- (void)resetCellColor
{
    // 根据cell是否编辑过来设置label的颜色
    if ([self hasEdit])
    {
        self.titleLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.titleLabel.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)hasEdit
{
    // 判断cell是否有编辑过数据
    if ((!self.dataModel.answer || [self.dataModel.answer length] == 0) &&
        (!self.dataModel.photoDataModels || [self.dataModel.photoDataModels count] == 0))
    {
        return NO;
    }
    
    return YES;
}

- (void)setDateHidden:(BOOL)hidden
{
    if (![self.dateCellView superview])
    {
        [self.contentView addSubview:self.dateCellView];
        [self.contentView bringSubviewToFront:self.dateCellView];
    }
    self.dateCellView.hidden = hidden;
}

@end
