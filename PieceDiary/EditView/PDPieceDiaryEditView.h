//
//  PDPieceDiaryEditView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDPieceDiaryEditViewDelegate <NSObject>

@required
- (void)displayPhotos;
- (void)showQuestionEditView;

@end

@interface PDPieceDiaryEditView : UIView

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<PDPieceDiaryEditViewDelegate> delegate;

- (void)resetEditViewWithShowKeyboardFrame:(CGRect)keyboardFrame;
- (void)resetEditViewByHideKeyboard;

@end
