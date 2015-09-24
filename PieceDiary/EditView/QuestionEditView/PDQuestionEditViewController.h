//
//  PDQuestionEditViewController.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDPieceCellDataModel;

@protocol PDQuestionEditViewControllerDelegate <NSObject>

- (void)setQuestionContentWithText:(NSString *)text;

@end

@interface PDQuestionEditViewController : UIViewController

@property (nonatomic, retain) id<PDQuestionEditViewControllerDelegate> delegate;

- (id)initWithDataModel:(PDPieceCellDataModel *)dataModel delegate:(id<PDQuestionEditViewControllerDelegate>)delegate;

@end
