//
//  PDPieceEditViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceEditViewController.h"
#import "PDPieceEditToolbar.h"
#import "PDPieceDiaryEditView.h"
#import "PDImagePickerController.h"

#define ToolbarHeight 56

@interface PDPieceEditViewController () <PDPieceEditToolbarDelegate, PDImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet PDPieceEditToolbar *toolbar;
@property (nonatomic, weak) IBOutlet PDPieceDiaryEditView *editView;

@end

@implementation PDPieceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.toolbar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyboardEevent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.editView.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardEvent];
}

- (void)addKeyboardEevent
{
    // 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeKeyboardEvent
{
    // 移除键盘事件监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.editView resetEditViewByHideKeyboard];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.editView convertRect:keyboardFrame fromView:self.view];
    
    [self.editView resetEditViewWithShowKeyboardFrame:keyboardFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PDPieceEditToolbarDelegate

- (void)returnPieceView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImagePicker
{
    PDImagePickerController *imagePickerController = [[PDImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (UIView *)inputAccessoryView
{
    // 键盘上的工具栏
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDPieceEditToolbar" owner:self.toolbar options:nil];
    UIView *toolbar = [nibViews firstObject];
    
    CGFloat toolbarHeight = ToolbarHeight;
    CGFloat toolbarWidth = CGRectGetWidth(self.view.frame);
    toolbar.frame = CGRectMake(0, 0, toolbarWidth, toolbarHeight);
    
    return toolbar;
}

#pragma mark - PDImagePickerControllerDelegate

- (void)pickFinishedWithPhotos:(NSArray *)photos
{
    
}

@end
