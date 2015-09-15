//
//  PDScaleAnimation.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDBaseAnimation.h"

@protocol PDScaleAnimationDelegate <NSObject>

- (CGRect)getCurrentItemRect;

@end

@interface PDScaleAnimation : PDBaseAnimation

@property (nonatomic, assign) id<PDScaleAnimationDelegate> delegate;

@end
