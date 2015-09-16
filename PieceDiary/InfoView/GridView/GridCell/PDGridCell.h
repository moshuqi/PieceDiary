//
//  PDGridCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/16.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDGridCell : UICollectionViewCell

- (void)setCellTitleWithText:(NSString *)text;
- (void)setQuantityWithNumber:(NSInteger *)number;

@end
