//
//  PDGridView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDGridViewDelegate <NSObject>

- (void)showDiaryTableView;
- (void)showGridTableView;
- (void)showPhotoTableView;
- (void)showQuestionTableView;

@end

@interface PDGridView : UIView

@property (nonatomic, assign) id<PDGridViewDelegate> delegate;

@end
