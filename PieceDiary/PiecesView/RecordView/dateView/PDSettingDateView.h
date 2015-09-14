//
//  PDSettingDateView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDSettingDateViewDelegate <NSObject>

@required
- (void)dateSettingCancel;

@end

@interface PDSettingDateView : UIView

@property (nonatomic, assign) id<PDSettingDateViewDelegate> delegate;

@end
