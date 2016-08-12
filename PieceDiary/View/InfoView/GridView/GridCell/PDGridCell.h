//
//  PDGridCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/16.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PDGridCellType)
{
    PDGridCellTypeDiary = 0,    // 日记
    PDGridCellTypeCrid,         // 格子
    PDGridCellTypeQuestion,     // 问题
    PDGridCellTypePhoto         // 图片
};

@interface PDGridCell : UICollectionViewCell

@property (nonatomic, assign) PDGridCellType type;

- (void)setCellTitleWithText:(NSString *)text;
- (void)setQuantityWithNumber:(NSInteger)number;

@end
