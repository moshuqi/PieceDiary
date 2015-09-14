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

@interface PDPieceEditViewController ()

@property (nonatomic, weak) IBOutlet PDPieceEditToolbar *toolbar;
@property (nonatomic, weak) IBOutlet PDPieceDiaryEditView *editView;

@end

@implementation PDPieceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDPieceEditToolbar" owner:self options:nil];
//    self.toolbar = [nibViews firstObject];
//    self.toolbar.frame = [self getToolbarFrameWithSuperviewSize:self.view.frame.size];
//    [self.view addSubview:self.toolbar];
    
}

//- (CGRect)getToolbarFrameWithSuperviewSize:(CGSize)size
//{
//    CGFloat toolbarHeight = self.toolbar.frame.size.height;
//    CGRect toolbarFrame = CGRectMake(0, size.height - toolbarHeight, size.width, toolbarHeight);
//    
//    return toolbarFrame;
//}

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
