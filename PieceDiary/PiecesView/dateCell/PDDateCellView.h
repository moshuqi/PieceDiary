//
//  PDDateCellView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/9.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDDateCellDataModel.h"

@interface PDDateCellView : UIView

- (void)setupWithDataModel:(PDDateCellDataModel *)dataModel;

- (void)setDateLabelsWithDate:(NSDate *)date;
- (void)setWeatherIconWithImage:(UIImage *)image;
- (void)setMoodIconWithImage:(UIImage *)image;

@end
