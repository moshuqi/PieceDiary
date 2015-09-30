//
//  PDTopBarView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDTopBarViewDelegate <NSObject>

- (void)infoTableViewReturn;

@end

@interface PDTopBarView : UIView

@property (nonatomic, weak) id<PDTopBarViewDelegate> delegate;

- (void)setTitleWithText:(NSString *)text;

@end
