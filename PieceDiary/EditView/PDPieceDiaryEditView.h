//
//  PDPieceDiaryEditView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDPieceDiaryEditView : UIView

@property (nonatomic, weak) IBOutlet UITextView *textView;

- (void)resetEditViewWithShowKeyboardFrame:(CGRect)keyboardFrame;
- (void)resetEditViewByHideKeyboard;

@end
