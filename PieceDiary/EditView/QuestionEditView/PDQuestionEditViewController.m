//
//  PDQuestionEditViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDQuestionEditViewController.h"
#import "PDPieceCellDataModel.h"
#import "PDDataManager.h"

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

- (NSString *)getOldQuestionContent
{
    return self.oldQuestion;
}

- (void)questionEditFinished
{
    // 问题编辑完成
    
    if (![self questionContentChanged])
    {
        // 编辑没有改变原来的值
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *question = self.textView.text;
    if ([self exsistSameQuestion:question])
    {
        [self showAlertTip];
    }
    else
    {
        [self.delegate questionEditViewController:self editQuestionContentText:question inDate:self.dataModel.date];
    }
}

- (BOOL)exsistSameQuestion:(NSString *)question
{
    // 判断当天是否已经存在相同的问题。同一天不允许存在相同的问题。
    PDDataManager *dataManager = [PDDataManager defaultManager];
    BOOL bQuestionContentExsist = [dataManager exsistQuestionContent:question];
    
    if (bQuestionContentExsist)
    {
        NSInteger questionID = [dataManager getQuestionIDWithQuestionContent:question];
        BOOL bDuplicate = [dataManager exsistQuestionID:questionID inDate:self.dataModel.date];
        
        if (bDuplicate)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)questionContentChanged
{
    NSString *question = self.textView.text;
    if ([question compare:self.oldQuestion] == NSOrderedSame)
    {
        return NO;
    }
    
    return YES;
}

- (void)showAlertTip
{
    // 提示在同一天里设置了相同的问题
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回答abcd" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    // 编辑内容为空时，完成按钮置灰。
    self.doneBtn.enabled = ([self.textView.text length] < 1) ? NO : YES;
}

@end
