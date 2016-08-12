//
//  PDRecordViewController.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "ViewController.h"

@class PDRecordViewController;

@protocol PDRecordViewControllerDelegate <NSObject>

- (void)recordViewControllerDismiss:(PDRecordViewController *)recordViewController;

@end

@interface PDRecordViewController : ViewController

@property (nonatomic, assign) id<PDRecordViewControllerDelegate> delegate;

- (id)initWithDate:(NSDate *)date;

@end
