//
//  PDPiecesViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/9.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPiecesViewController.h"
#import "PDDateCellView.h"
#import "PDPieceDiaryView.h"

#define kOriginY    20

@interface PDPiecesViewController ()

@property (nonatomic, retain) PDPieceDiaryView *pieceDiaryView;

@end

@implementation PDPiecesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDPieceDiaryView" owner:self options:nil];
    self.pieceDiaryView = [nibViews objectAtIndex:0];
    self.pieceDiaryView.frame = [self getPieceDiaryFrame];
    
    [self.view addSubview:self.pieceDiaryView];
    self.pieceDiaryView.backgroundColor = [UIColor grayColor];
    
//    [self initPiecesCollectionView];

}

- (CGRect)getPieceDiaryFrame
{
    CGRect frame = CGRectMake(0, kOriginY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kOriginY);
    return frame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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
