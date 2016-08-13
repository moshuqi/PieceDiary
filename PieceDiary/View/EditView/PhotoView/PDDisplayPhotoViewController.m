//
//  PDDisplayPhotoViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDDisplayPhotoViewController.h"
#import "PDPhotoData.h"
#import "PDDataManager.h"

@interface PDDisplayPhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *toolbarView;
@property (nonatomic, retain) NSMutableArray<PDPhotoData *> *photoDatas;

@property (nonatomic, weak) IBOutlet UIButton *previousBtn;
@property (nonatomic, weak) IBOutlet UIButton *nextBtn;
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIViewController *deleteConfirmViewController;

@end

@implementation PDDisplayPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupImageView];
    self.index = 0;
    [self resetButtonsState];
}

- (void)setupImageView
{
//    [self.view addSubview:self.imageView];
    
    PDPhotoData *data = [self.photoDatas firstObject];
    UIImage *image = data.image;
    [self resetImageViewFrameWithImage:image];
}

- (void)resetButtonsState
{
    self.previousBtn.enabled = YES;
    self.nextBtn.enabled = YES;
    
    if (self.index == 0)
    {
        self.previousBtn.enabled = NO;
    }
    if (self.index == [self.photoDatas count] - 1)
    {
        self.nextBtn.enabled = NO;
    }
}

- (void)resetImageViewFrameWithImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (id)initWithPhotoDatas:(NSArray *)photoDatas
{
    self = [super init];
    if (self)
    {
        self.photoDatas = [NSMutableArray arrayWithArray:photoDatas];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchedCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchedDelete:(id)sender
{
    [self showDeleteConfirmView];
}

- (IBAction)previousPhoto:(id)sender
{
    self.index -= 1;
    [self photoChanged];
    [self resetButtonsState];
}

- (IBAction)nextPhoto:(id)sender
{
    self.index += 1;
    [self photoChanged];
    [self resetButtonsState];
}

- (void)photoChanged
{
    PDPhotoData *photoData = self.photoDatas[self.index];
    UIImage *image = photoData.image;
    self.imageView.image = image;
}

- (void)deletePhoto:(id)sender
{
    PDPhotoData *data = self.photoDatas[self.index];
    NSInteger photoID = data.photoID;
    
    PDDataManager *dataManager = [PDDataManager defaultManager];
    [dataManager deletePhotoWithPhotoID:photoID];
    
    if ([self.photoDatas count] == 1)
    {
        // 此时已经没有图片,直接退出photo视图
        [self.deleteConfirmViewController dismissViewControllerAnimated:NO completion:^(){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    NSInteger newIndex = self.index;
    if (newIndex == [self.photoDatas count] - 1)
    {
        newIndex--;
    }
    
    [self.photoDatas removeObjectAtIndex:self.index];
    self.index = newIndex;
    [self photoChanged];
    [self resetButtonsState];
    
    [self.deleteConfirmViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showDeleteConfirmView
{
    // 显示确认删除弹窗
    self.deleteConfirmViewController = [UIViewController new];
    self.deleteConfirmViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popoverPresentationController = self.deleteConfirmViewController.popoverPresentationController;
    popoverPresentationController.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    CGSize contentSize = CGSizeMake(320, 120);
    self.deleteConfirmViewController.preferredContentSize = contentSize;
    
    CGRect frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    UIView *confirmView = [self getDeleteConfirmViewWithFrame:frame];
    [self.deleteConfirmViewController.view addSubview:confirmView];
    
    [self presentViewController:self.deleteConfirmViewController animated:YES completion:nil];
}

- (UIView *)getDeleteConfirmViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    CGFloat labelHeight = 56;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    if (height < labelHeight)
    {
        PDLog(@"高度有误。");
    }
    
    // 提示标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, labelHeight)];
    label.text = @"确认删除这张照片？";
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:22]];
    
    [view addSubview:label];
    
    // 删除按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonHeight = height - labelHeight;
    button.frame = CGRectMake(0, labelHeight, width, buttonHeight);
    
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
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
