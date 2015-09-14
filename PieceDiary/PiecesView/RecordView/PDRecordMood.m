//
//  PDRecordMood.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordMood.h"

@implementation PDRecordMood

- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray *homeViewXib = [[NSBundle mainBundle] loadNibNamed:@"PDIconSettingView" owner:self options:nil];
        self.iconView = [homeViewXib firstObject];
        
        NSArray *iconArray = [self getIconDictArray];
        [self.iconView setIconsWithDictArray:iconArray];
    }
    
    return self;
}

- (NSArray *)getIconDictArray
{
    // 获取选中和正常状态时的图标
    NSMutableArray *dictArray = [NSMutableArray array];
    
    UIImage *normalImage = [UIImage imageNamed:@"mood.jpg"];
    UIImage *selectedImage = [UIImage imageNamed:@"1.jpg"];
    
    NSDictionary *dic1 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic1];
    
    NSDictionary *dic2 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic2];
    
    NSDictionary *dic3 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic3];
    
    NSDictionary *dic4 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic4];
    
    NSDictionary *dic5 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic5];
    
    NSDictionary *dic6 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic6];
    
    NSDictionary *dic7 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic7];
    
    NSDictionary *dic8 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic8];
    
    return dictArray;
}


@end
