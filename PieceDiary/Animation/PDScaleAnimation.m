//
//  PDScaleAnimation.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDScaleAnimation.h"

@implementation PDScaleAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect fromRect = [self.delegate getCurrentItemRect];
    
    
    if (self.animationType == AnimationTypePresent)
    {
        // 视图弹出时自定义动画
        
        // 临时视图，放大动画完成之后移除
        UIView *animatedView = [[UIView alloc] initWithFrame:fromRect];
        animatedView.backgroundColor = [UIColor whiteColor];
        
        CGFloat originY = 20;
        toViewController.view.frame = CGRectMake(0, originY, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame) - originY);
        toViewController.view.hidden = YES;
        
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        [containerView insertSubview:animatedView aboveSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            CGFloat toolbarHeight = 44;
            CGRect newRect = CGRectMake(0, originY, containerView.frame.size.width, containerView.frame.size.height - originY - toolbarHeight);
            animatedView.frame = newRect;
            
        }
                         completion:^(BOOL finished)
        {
            toViewController.view.hidden = NO;
            [animatedView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    else if (self.animationType == AnimationTypeDismiss)
    {
        // 视图消失时自定义动画
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        // 临时视图，缩小动画完成后移除
        UIView *animatedView = [[UIView alloc] initWithFrame:fromViewController.view.frame];
        animatedView.backgroundColor = [UIColor whiteColor];
        [containerView insertSubview:animatedView aboveSubview:fromViewController.view];
        fromViewController.view.hidden = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            animatedView.frame = fromRect;
            
        }
                         completion:^(BOOL finished)
        {
            fromViewController.view.hidden = NO;
            [animatedView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

@end
