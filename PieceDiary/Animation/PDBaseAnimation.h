//
//  PDBaseAnimation.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AnimationTypePresent,
    AnimationTypeDismiss
} PDAnimationType;

@interface PDBaseAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PDAnimationType animationType;

@end
