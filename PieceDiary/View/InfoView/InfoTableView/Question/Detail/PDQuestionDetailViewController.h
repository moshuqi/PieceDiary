//
//  PDQuestionDetailViewController.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDQuestionDetailViewController <NSObject>

@required
- (void)detailViewControllerReturn;
- (void)didSelectedWithDate:(NSDate *)date;

@end

@interface PDQuestionDetailViewController : UIViewController

@property (nonatomic, assign) id<PDQuestionDetailViewController> delegate;

- (id)initWithDataArray:(NSArray *)array titleText:(NSString *)title;

@end
