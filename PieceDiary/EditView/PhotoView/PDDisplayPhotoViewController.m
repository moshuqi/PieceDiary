//
//  PDDisplayPhotoViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDDisplayPhotoViewController.h"

@interface PDDisplayPhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *toolbarView;
@property (nonatomic, retain) NSMutableArray *photos;


@end

@implementation PDDisplayPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupImageView];
}

- (void)setupImageView
{
//    [self.view addSubview:self.imageView];
    
    UIImage *image = [self.photos firstObject];
    [self resetImageViewFrameWithImage:image];
}

- (void)resetImageViewFrameWithImage:(UIImage *)image
{
    self.imageView.image = image;

    // 按比例设置imageView
//    CGFloat imgWidth = image.size.width;
//    CGFloat imgHeight = image.size.height;
//    
//    CGFloat toolbarHeight = CGRectGetHeight(self.toolbarView.frame);
//    CGFloat height = CGRectGetHeight(self.view.bounds) - toolbarHeight;
//    CGFloat width = CGRectGetWidth(self.view.bounds);
//    
//    CGFloat scale = height / imgHeight;
//    CGFloat imgViewWidth = imgWidth * scale;
//    CGFloat imgViewHeight = imgHeight * scale;
//    
//    CGRect frame = CGRectMake(0, 0, imgViewWidth, imgViewHeight);
//    self.imageView.frame = frame;
//    self.imageView.center = CGPointMake(width / 2, height / 2);
    
    
}

- (id)initWithPhotos:(NSArray *)photos
{
    self = [super init];
    if (self)
    {
        self.photos = [NSMutableArray arrayWithArray:photos];
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
