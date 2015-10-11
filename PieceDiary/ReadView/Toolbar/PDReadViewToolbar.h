//
//  PDReadViewToolbar.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDReadViewToolbarDelegate <NSObject>

- (void)readViewReturn;

@end

@interface PDReadViewToolbar : UIView

@property (nonatomic, weak) id<PDReadViewToolbarDelegate> delegate;

@end
