//
//  PDPieceDiaryEditView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceDiaryEditView.h"
#import "PDPieceCellDataModel.h"

@interface PDPieceDiaryEditView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UILabel *photoCountLabel;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) PDPieceCellDataModel *dataModel;

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
    [self addGesture];
    [self addPhotoCountLabelToImageView];
}

- (void)addGesture
{
    // 点击展示图片的手势
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGesture1];
    
    // 点击问题标签进去编辑问题视图
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapped:)];
    tapGesture2.numberOfTapsRequired = 1;
    [self.titleLabel addGestureRecognizer:tapGesture2];
}

- (void)addPhotoCountLabelToImageView
{
    CGFloat w = 20;
    CGFloat imageViewW = CGRectGetWidth(self.imageView.frame);
    
    CGRect frame = CGRectMake(imageViewW - w, imageViewW - w, w, w);
    self.photoCountLabel = [[UILabel alloc] initWithFrame:frame];
    
    self.photoCountLabel.textColor = [UIColor whiteColor];
    self.photoCountLabel.textAlignment = NSTextAlignmentCenter;
    self.photoCountLabel.backgroundColor = [UIColor redColor];
    self.photoCountLabel.layer.cornerRadius = w / 2;
    self.photoCountLabel.clipsToBounds = YES;
    
    [self.imageView addSubview:self.photoCountLabel];
}

- (void)imageViewTapped:(UIGestureRecognizer *)gesture
{
    [self.delegate displayPhotos];
}

- (void)titleLabelTapped:(UIGestureRecognizer *)gesture
{
    [self.delegate showQuestionEditViewWithDataModel:self.dataModel];
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

- (void)setPhotosWithArray:(NSArray *)array
{
    self.photos = array;
    NSInteger count = [self.photos count];
    
    if (count < 1)
    {
        self.imageView.hidden = YES;
    }
    else
    {
        self.imageView.hidden = NO;
        self.imageView.image = [self.photos firstObject];
        self.photoCountLabel.text = [NSString stringWithFormat:@"%ld", count];
    }
}

- (void)setQuestionContentWithText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (void)setEditViewWithDataModel:(PDPieceCellDataModel *)dataModel
{
    self.dataModel = dataModel;
    self.titleLabel.text = dataModel.question;
    self.textView.text = dataModel.answer;
    self.photos = dataModel.photos;
}


@end
