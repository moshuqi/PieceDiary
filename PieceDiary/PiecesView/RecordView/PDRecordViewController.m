//
//  PDRecordViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordViewController.h"
#import "PDSettingView.h"

@interface PDRecordViewController () <PDSettingViewDelegate>

@property (nonatomic, retain) PDSettingView *recordView;

@end

@implementation PDRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDSettingView" owner:self options:nil];
    self.recordView = [nibViews firstObject];
    self.recordView.frame = self.view.bounds;
    
    self.recordView.delegate = self;
    [self.view addSubview:self.recordView];
}

#pragma mark - PDSettingViewDelegate

- (void)settingDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
