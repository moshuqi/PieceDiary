//
//  PDPieceDiaryEditView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceDiaryEditView.h"

@interface PDPieceDiaryEditView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation PDPieceDiaryEditView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDPieceDiaryEditView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)resetEditViewWithShowKeyboardFrame:(CGRect)keyboardFrame
{
    // 弹出软键盘时调整textView的高度以显示全内容
    CGFloat textViewHeight = keyboardFrame.origin.y - self.textView.frame.origin.y - 20;
    CGRect frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, textViewHeight);
    self.textView.frame = frame;
    
    // 调整imageView高度，显示在键盘上方
    [self resetImageViewOriginYWithTextViewHeight:textViewHeight];
}

- (void)resetEditViewByHideKeyboard
{
    // 软键盘收起时恢复原来的高度
    CGFloat textViewHeight = CGRectGetHeight(self.frame) - CGRectGetHeight(self.titleLabel.frame);
    CGRect frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, textViewHeight);
    self.textView.frame = frame;
    
    // imageView高度恢复
    [self resetImageViewOriginYWithTextViewHeight:textViewHeight];
}

- (void)resetImageViewOriginYWithTextViewHeight:(CGFloat)textViewHeight
{
    CGFloat distance = 20;  // 与底边的间距
    CGFloat originY = self.textView.frame.origin.y + textViewHeight - CGRectGetHeight(self.imageView.frame) - distance;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, originY, self.imageView.frame.size.width, self.imageView.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
