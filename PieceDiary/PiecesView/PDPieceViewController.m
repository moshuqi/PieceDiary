//
//  PDPieceViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/9.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceViewController.h"
#import "PDDateCellView.h"
#import "PDPieceDiaryView.h"
#import "PDRecordViewController.h"
#import "PDPieceEditViewController.h"
#import "ScaleAnimation.h"

#define kOriginY    20

@interface PDPieceViewController ()<PDPieceDiaryViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, retain) PDPieceDiaryView *pieceDiaryView;

@end

@implementation PDPieceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDPieceDiaryView" owner:self options:nil];
    self.pieceDiaryView = [nibViews objectAtIndex:0];
    self.pieceDiaryView.frame = [self getPieceDiaryFrame];
    self.pieceDiaryView.delegate = self;
    
    [self.view addSubview:self.pieceDiaryView];
    self.pieceDiaryView.backgroundColor = [UIColor grayColor];
}

- (CGRect)getPieceDiaryFrame
{
    CGRect frame = CGRectMake(0, kOriginY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kOriginY);
    return frame;
}

- (void)enterPieceEditView
{
    // 进入编辑界面
    PDPieceEditViewController *pieceEditViewController = [[PDPieceEditViewController alloc] init];
//    pieceEditViewController.transitioningDelegate = self;
    
    [self presentViewController:pieceEditViewController animated:YES completion:nil];
}

- (void)showRecordView
{
    // 显示心情天气记录视图
    PDRecordViewController *recordViewController = [[PDRecordViewController alloc] init];
    
    recordViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:recordViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    ScaleAnimation *scaleAnimation = [[ScaleAnimation alloc] init];
    return scaleAnimation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ScaleAnimation *scaleAnimation = [[ScaleAnimation alloc] init];
    return scaleAnimation;
}

#pragma mark - PDPieceDiaryViewDelegate

- (void)pieceDiaryView:(PDPieceDiaryView *)pieceDiaryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self enterPieceEditView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
