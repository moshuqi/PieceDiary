//
//  PDWeekdayView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDWeekdayViewDelegate <NSObject>

@required
- (void)weekdaySelectedDate:(NSDate *)date;

@end

@interface PDWeekdayView : UIView

@property (nonatomic, weak) id<PDWeekdayViewDelegate> delegate;

- (void)setupWeekdayButtonsWithDate:(NSDate *)date;

@end
