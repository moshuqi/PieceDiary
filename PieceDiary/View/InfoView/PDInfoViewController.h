//
//  PDInfoViewController.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDInfoViewController;

@protocol PDInfoViewControllerDelegate <NSObject>

@required
- (void)infoViewController:(PDInfoViewController *)infoViewController dismissAndEnterPieceViewWithDate:(NSDate *)date;

@end

@interface PDInfoViewController : UIViewController

@property (nonatomic, weak) id<PDInfoViewControllerDelegate> delegate;

- (id)initWithDate:(NSDate *)date;

@end
