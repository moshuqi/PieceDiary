//
//  PDIconsView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDIconsView.h"

#define kNumberOfIcons  4

@interface PDIconsView ()

// 最多只显示4张图片，大于4张显示省略
@property (nonatomic, weak) IBOutlet UIImageView *icon1;
@property (nonatomic, weak) IBOutlet UIImageView *icon2;
@property (nonatomic, weak) IBOutlet UIImageView *icon3;
@property (nonatomic, weak) IBOutlet UIImageView *icon4;
@property (nonatomic, weak) IBOutlet UILabel *moreIconLabel;

@end

@implementation PDIconsView

- (void)awakeFromNib
{
    // Initialization code
    
    CGFloat d = self.icon1.frame.size.width;
    
    self.icon1.layer.cornerRadius = d;
    self.icon1.clipsToBounds = YES;
    self.icon2.layer.cornerRadius = d / 2;
    self.icon3.layer.cornerRadius = d / 2;
    self.icon4.layer.cornerRadius = d / 2;
}

- (void)setIconsWithImages:(NSArray *)images
{
    NSInteger count = [images count];
    if (count < 1)
    {
        NSLog(@"没有图片.");
        return;
    }
    
    if (count > kNumberOfIcons)
    {
        self.moreIconLabel.hidden = NO;
    }
    else
    {
        self.moreIconLabel.hidden = YES;
    }
    
    NSArray *icons = @[self.icon1, self.icon2, self.icon3, self.icon4];
    for (NSInteger i = 0; i < count && i < kNumberOfIcons; i++)
    {
        UIImageView *imageView = icons[i];
        UIImage *image = images[i];
        
        imageView.image = image;
        imageView.hidden = NO;
    }
    
    // 图片少于4张
    if (kNumberOfIcons > count)
    {
        for (NSInteger i = 0; i < kNumberOfIcons - count; i++)
        {
            UIImageView *imageView = icons[kNumberOfIcons - 1 - i];
            imageView.hidden = YES;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
