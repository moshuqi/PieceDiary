//
//  PDRecordSetting.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/4.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDRecordSetting.h"

@implementation PDRecordSetting

- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray *homeViewXib = [[NSBundle mainBundle] loadNibNamed:[self getNibName] owner:self options:nil];
        self.iconView = [homeViewXib firstObject];
        
        NSArray *iconArray = [self getIconDictArray];
        [self.iconView setIconsWithDictArray:iconArray];
        
        [self setupRecordButtons];
    }
    
    return self;
}

- (void)setupRecordButtons
{
    NSArray *buttonArray = [self.iconView getRecordButtons];
    for (NSInteger i = 0; i < [buttonArray count]; i++)
    {
        UIButton *button = buttonArray[i];
        NSInteger tag = i+1;
        button.tag = tag;
        
        [button addTarget:self action:@selector(recordButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)recordButtonTouched:(UIButton *)button
{
    [self resetButtonsStateWithTouchedButton:button];
}

- (void)resetButtonsStateWithTouchedButton:(UIButton *)button
{
    // 点击的按钮若是已被选中，则取消选中，这时没有被设置
    if (button.selected)
    {
        button.selected = NO;
        [self cancelRecord];
        [self.iconView setSettingViewTitle:[self getNoSettingTip]];
        return;
    }
    
    // 点击的按钮被选中
    NSArray *buttons = [self.iconView getRecordButtons];
    for (UIButton *btn in buttons)
    {
        btn.selected = NO;
    }
    button.selected = YES;
    
    [self.iconView setSettingViewTitle:[self getTitleTextWithButtonTag:button.tag]];
}

- (void)setSelectedWithString:(NSString *)string
{
    if (!string && ([string length] < 1))
    {
        [self.iconView setSettingViewTitle:[self getNoSettingTip]];
        return;
    }
    
    NSInteger tag = [self getTagWithString:string];
    NSArray *buttons = [self.iconView getRecordButtons];
    
    for (UIButton *btn in buttons)
    {
        if (btn.tag == tag)
        {
            btn.selected = YES;
            break;
        }
    }
    
    [self.iconView setSettingViewTitle:string];
}

- (NSString *)getSettingString
{
    NSString *string = nil;
    
    NSInteger tag = -1;
    NSArray *buttons = [self.iconView getRecordButtons];
    BOOL isSelected = NO;
    for (UIButton *btn in buttons)
    {
        if (btn.selected)
        {
            tag = btn.tag;
            isSelected = YES;
            break;
        }
    }
    
    if (isSelected)
    {
        string = [self getTitleTextWithButtonTag:tag];
    }
    
    return string;
}

- (void)cancelRecord
{
    // 子类重载
}

- (NSString *)getTitleTextWithButtonTag:(NSInteger)tag
{
    // 子类重载
    return nil;
}

- (NSString *)getNoSettingTip
{
    // 子类重载
    return nil;
}

- (NSArray *)getIconDictArray
{
    NSMutableArray *dictArray = [NSMutableArray array];
    
    // 枚举值都从1开始，一共有8个
    for (NSInteger tag = 1; tag <= 8; tag++)
    {
        UIImage *normalImage = [self getNormalImageWithTag:tag];
        UIImage *selectedImage = [self getSelectedImageWithTag:tag];
        NSDictionary *dic = @{PDIconSettingNormalImageKey : normalImage,
                               PDIconSettingSelectedImageKey : selectedImage};
        [dictArray addObject:dic];
    }
    
    return dictArray;
}

- (UIImage *)getNormalImageWithTag:(NSInteger)tag
{
    NSString *imageName = [self getImageNameWithTag:tag];
    imageName = [imageName stringByAppendingString:@".png"];
    
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

- (UIImage *)getSelectedImageWithTag:(NSInteger)tag
{
    NSString *imageName = [self getImageNameWithTag:tag];
    NSString *extStr = [NSString stringWithFormat:@"%@.png", RecordIconSelected];
    imageName = [imageName stringByAppendingString:extStr];
    
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

- (NSString *)getImageNameWithTag:(NSInteger)tag
{
    // 子类重载
    return nil;
}

- (NSString *)getNibName
{
    // 子类重载
    return nil;
}

- (NSInteger)getTagWithString:(NSString *)string
{
    // 子类重载
    return -1;
}

@end
