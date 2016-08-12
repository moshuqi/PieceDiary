//
//  PDWeekdayCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , PDWeekdayCellState)
{
    PDWeekdayCellStateNoDiary = 1,     // 没有日记内容
    PDWeekdayCellStateHasDiary,        // 有日记内容
    PDWeekdayCellStateCurrentDay       // 本周当天
};

@interface PDWeekdayCell : UICollectionViewCell

- (void)setupWithWeekday:(NSString *)weekday day:(NSString *)day state:(PDWeekdayCellState)state;

@end
