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
#import "PDThisWeekView.h"
#import "PDDefine.h"

@interface PDInfoViewController () <PDGridViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet PDGridView *gridView;
@property (nonatomic, weak) IBOutlet PDThisWeekView *thisWeekView;
@property (nonatomic, weak) IBOutlet UIView *colorView;
@property (nonatomic, retain) NSDate *date;

@end

@implementation PDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BackgroudGrayColor;
    
    self.gridView.delegate = self;
    
    [self addGesture];
    [self.thisWeekView setupThisWeekWithDate:self.date];
    
    self.colorView.backgroundColor = MainBlueColor;
}

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        self.date = date;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGesture
{
    // 视图加上手势，点击时返回之前的视图控制器
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    
    [self.view addGestureRecognizer:gesture];
}



- (void)tapBackgroundView:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.gridView.frame, point) &&
        !CGRectContainsPoint(self.thisWeekView.frame, point)) {
        return YES;
    }
    
    return NO;
}

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
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
