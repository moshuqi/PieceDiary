//
//  PDPieceDiaryEditView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDPieceCellData;

@protocol PDPieceDiaryEditViewDelegate <NSObject>

@required
- (void)displayPhotos;
- (void)showQuestionEditViewWithData:(PDPieceCellData *)data;

@end

@interface PDPieceDiaryEditView : UIView

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<PDPieceDiaryEditViewDelegate> delegate;

- (void)resetEditViewWithShowKeyboardFrame:(CGRect)keyboardFrame;
- (void)resetEditViewByHideKeyboard;
- (void)setEditViewWithData:(PDPieceCellData *)data;
- (void)setQuestionContentWithText:(NSString *)text;
- (void)setupImageViewWithPhotoDatas:(NSArray *)datas;

@end
