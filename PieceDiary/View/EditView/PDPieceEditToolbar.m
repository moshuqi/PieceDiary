//
//  PDPieceEditToolbar.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceEditToolbar.h"

@interface PDPieceEditToolbar ()

@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;
@property (nonatomic, weak) IBOutlet UIButton *returnPieceViewBtn;
@property (nonatomic, weak) IBOutlet UIButton *addImageBtn;

@end

@implementation PDPieceEditToolbar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDPieceEditToolbar" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupButtonsState];
}

- (void)setupButtonsState
{
//    // 左边箭头
//    UIImage *leftArrowImage = [UIImage imageNamed:@"leftArrow.png"];
//    [self.leftBtn setImage:leftArrowImage forState:UIControlStateNormal];
//    
//    UIImage *leftArrowHighlightImage = [UIImage imageNamed:@"leftArrowHighlight.png"];
//    [self.leftBtn setImage:leftArrowHighlightImage forState:UIControlStateHighlighted];
//    [self.leftBtn setImage:leftArrowHighlightImage forState:UIControlStateDisabled];
//    
//    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 25, 20, 25);
//    
//    // 右边箭头
//    UIImage *rightArrowImage = [UIImage imageNamed:@"rightArrow.png"];
//    [self.rightBtn setImage:rightArrowImage forState:UIControlStateNormal];
//    
//    UIImage *rightArrowHighlightImage = [UIImage imageNamed:@"rightArrowHighlight.png"];
//    [self.rightBtn setImage:rightArrowHighlightImage forState:UIControlStateHighlighted];
//    [self.rightBtn setImage:rightArrowHighlightImage forState:UIControlStateDisabled];
//    
//    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (IBAction)touchedReturnBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(returnPieceView)])
    {
        [self.delegate returnPieceView];
    }
}

- (IBAction)touchedAddImageBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(showImagePicker)])
    {
        [self.delegate showImagePicker];
    }
}

- (IBAction)touchedLeftBtn:(id)sender
{
    // 前往上一个cell
    if ([self.delegate respondsToSelector:@selector(previousPieceCellEditView)])
    {
        [self.delegate previousPieceCellEditView];
    }
}

- (IBAction)touchedRightBtn:(id)sender
{
    // 前往下一个cell
    if ([self.delegate respondsToSelector:@selector(nextPieceCellEditView)])
    {
        [self.delegate nextPieceCellEditView];
    }
}

- (void)setLeftBtnEnabled:(BOOL)enabled
{
    self.leftBtn.enabled = enabled;
}

- (void)setRightBtnEnabled:(BOOL)enabled
{
    self.rightBtn.enabled = enabled;
}

@end
