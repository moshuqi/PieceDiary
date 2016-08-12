//
//  PDRecordDateView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDRecordDateViewDelegate <NSObject>

- (void)enterSettingDateView;

@end

@interface PDRecordDateView : UIView

@property (nonatomic, assign) id<PDRecordDateViewDelegate> delegate;

- (void)setDateStringWithDate:(NSDate *)date;

@end
