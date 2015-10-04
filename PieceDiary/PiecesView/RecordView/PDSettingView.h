//
//  PDSettingView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/11.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDSettingViewDelegate <NSObject>

@required
- (void)settingDone:(id)sender;

@end

@interface PDSettingView : UIView

@property (nonatomic, assign)  id<PDSettingViewDelegate> delegate;

- (void)setupSettingViewWithDate:(NSDate *)date;
- (NSString *)getWeatherSettingString;
- (NSString *)getMoodSettingString;

@end
