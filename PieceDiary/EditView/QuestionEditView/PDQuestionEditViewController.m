//
//  PDQuestionEditViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDQuestionEditViewController.h"
#import "PDPieceCellDataModel.h"

@interface PDQuestionEditViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *doneBtn;
@property (nonatomic, retain) PDPieceCellDataModel *dataModel;
@property (nonatomic, copy) NSString *oldQuestion;  // 保存初始值，完成时判断是否有更改

@end

@implementation PDQuestionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.text = self.dataModel.question;
    self.oldQuestion = self.dataModel.question;
    self.textView.delegate = self;
}

- (id)initWithDataModel:(PDPieceCellDataModel *)dataModel delegate:(id<PDQuestionEditViewControllerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.dataModel = dataModel;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)questionEditCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)questionEditDone:(id)sender
{
    [self questionEditFinished];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)questionEditFinished
{
    // 问题编辑完成
    
    NSString *question = self.textView.text;
    if ([question compare:self.oldQuestion] == NSOrderedSame)
    {
        // 编辑没有改变原来的值
        return;
    }
    
    // 判断当天是否已经存在相同的问题。同一天不允许存在相同的问题。
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    // 编辑内容为空时，完成按钮置灰。
    self.doneBtn.enabled = ([self.textView.text length] < 1) ? NO : YES;
}

@end
