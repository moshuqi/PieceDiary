//
//  PDQuestionEditViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDQuestionEditViewController.h"

@interface PDQuestionEditViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation PDQuestionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
