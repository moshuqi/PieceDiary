//
//  PDBaseInfoViewController.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDBaseInfoViewController;

@protocol PDBaseInfoViewControllerDelegate <NSObject>

@required
- (void)baseInfoViewController:(PDBaseInfoViewController *)baseInfoViewController dismissAndEnterPieceViewWithDate:(NSDate *)date;

@end

@interface PDBaseInfoViewController : UIViewController

@property (nonatomic, weak) id<PDBaseInfoViewControllerDelegate> baseVCDelegate;

@end
