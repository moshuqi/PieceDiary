//
//  PDInfoViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDInfoViewController.h"
#import "PDGridView.h"
#import "PDDiaryInfoTableViewController.h"
#import "PDGridInfoViewController.h"
#import "PDPhotoInfoViewController.h"
#import "PDQuestionInfoViewController.h"

@interface PDInfoViewController () <PDGridViewDelegate>

@property (nonatomic, weak) IBOutlet PDGridView *gridView;

@end

@implementation PDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.gridView.delegate = self;
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

#pragma mark - PDGridViewDelegate

- (void)showDiaryTableView
{
    PDDiaryInfoTableViewController *viewController = [PDDiaryInfoTableViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)showGridTableView
{
    PDGridInfoViewController *viewController = [PDGridInfoViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)showPhotoTableView
{
    PDPhotoInfoViewController *viewController = [PDPhotoInfoViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)showQuestionTableView
{
    PDQuestionInfoViewController *viewController = [PDQuestionInfoViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
