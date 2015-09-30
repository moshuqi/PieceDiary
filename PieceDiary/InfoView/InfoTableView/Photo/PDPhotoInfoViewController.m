//
//  PDPhotoInfoViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDPhotoInfoViewController.h"
#import "PDTopBarView.h"

@interface PDPhotoInfoViewController () <PDTopBarViewDelegate>

@property (nonatomic, weak) IBOutlet PDTopBarView *topBar;

@end

@implementation PDPhotoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topBar.delegate = self;
    [self.topBar setTitleWithText:@"照片"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PDTopBarViewDelegate

- (void)infoTableViewReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
