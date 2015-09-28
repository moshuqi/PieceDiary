//
//  PDDisplayPhotoViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDDisplayPhotoViewController.h"
#import "PDPhotoDataModel.h"

@interface PDDisplayPhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *toolbarView;
@property (nonatomic, retain) NSMutableArray *photoDataModels;

@property (nonatomic, weak) IBOutlet UIButton *previousBtn;
@property (nonatomic, weak) IBOutlet UIButton *nextBtn;

@property (nonatomic, assign) NSInteger index;

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
    
    PDPhotoDataModel *dataModel = [self.photoDataModels firstObject];
    UIImage *image = dataModel.image;
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
    else if (self.index == [self.photoDataModels count] - 1)
    {
        self.nextBtn.enabled = NO;
    }
}

- (void)resetImageViewFrameWithImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (id)initWithPhotoDataModels:(NSArray *)photoDataModels
{
    self = [super init];
    if (self)
    {
        self.photoDataModels = [NSMutableArray arrayWithArray:photoDataModels];
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
    PDPhotoDataModel *photoDataModel = self.photoDataModels[self.index];
    UIImage *image = photoDataModel.image;
    self.imageView.image = image;
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
