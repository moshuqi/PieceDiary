//
//  PDPieceEditToolbar.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDPieceEditToolbarDelegate <NSObject>

@optional
- (void)returnPieceView;
- (void)showImagePicker;
- (void)previousPieceCellEditView;
- (void)nextPieceCellEditView;

@end

@interface PDPieceEditToolbar : UIView

@property (nonatomic, assign) id<PDPieceEditToolbarDelegate> delegate;

- (void)setLeftBtnEnabled:(BOOL)enabled;
- (void)setRightBtnEnabled:(BOOL)enabled;

@end
