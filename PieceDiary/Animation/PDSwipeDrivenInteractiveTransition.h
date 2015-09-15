//
//  PDSwipeDrivenInteractiveTransition.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDSwipeDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

- (void)wireToViewController:(UIViewController*)viewController;

@end
