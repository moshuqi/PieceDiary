//
//  PDThisWeekView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDThisWeekViewDelegate <NSObject>

@required
- (void)thisWeekSelectedDate:(NSDate *)date;

@end

@interface PDThisWeekView : UIView

@property (nonatomic, weak) id<PDThisWeekViewDelegate> delegate;

- (void)setupThisWeekWithDate:(NSDate *)date;

@end
