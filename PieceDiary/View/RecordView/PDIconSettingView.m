//
//  PDIconSettingView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/11.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDIconSettingView.h"

@implementation PDIconSettingView

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLabel.textColor = TitleTextGrayColor;
}

- (NSArray *)getRecordButtons
{
    NSArray *btnArray = @[self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8];
    return btnArray;
}

- (void)setIconsWithDictArray:(NSArray *)dictArray
{
    NSInteger numberOfBtns = 8;
    if ([dictArray count] != numberOfBtns)
    {
        PDLog(@"数组个数不对。");
        return;
    }
    
    NSArray *btnArray = @[self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8];
    for (NSInteger i = 0; i < numberOfBtns; i++)
    {
        if (![dictArray[i] isKindOfClass:[NSDictionary class]])
        {
            PDLog(@"数组元素类型不为NSDictionary");
        }
        
        NSDictionary *dict = dictArray[i];
        UIImage *normalImage = [dict valueForKey:PDIconSettingNormalImageKey];
        UIImage *selectedImage = [dict valueForKey:PDIconSettingSelectedImageKey];
        
        UIButton *btn = btnArray[i];
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:selectedImage forState:UIControlStateHighlighted];
        [btn setImage:selectedImage forState:UIControlStateSelected];
        
        CGFloat v = 20;
        CGFloat h = 40;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(v,h,v,h)];
    }
}

- (void)setSettingViewTitle:(NSString *)title
{
    self.titleLabel.text = title;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

