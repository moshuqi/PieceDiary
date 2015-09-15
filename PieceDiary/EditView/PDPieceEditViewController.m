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

@interface PDPieceEditViewController () <PDPieceEditToolbarDelegate>

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PDPieceEditToolbarDelegate

- (void)returnPieceView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
