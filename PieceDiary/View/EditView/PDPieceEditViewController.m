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
#import "PDImagePickerController.h"
#import "PDDisplayPhotoViewController.h"
#import "PDQuestionEditViewController.h"
#import "PDPieceCellData.h"
#import "PDDataManager.h"
#import "PDPhotoData.h"

#define ToolbarHeight 56

typedef NS_ENUM(NSInteger, EditPieceCellChangeType) {
    EditPieceCellChangeTypePrevious,    // 上一个
    EditPieceCellChangeTypeNext         // 下一个
};

@interface PDPieceEditViewController () <PDPieceEditToolbarDelegate, PDImagePickerControllerDelegate, PDPieceDiaryEditViewDelegate, PDDisplayPhotoViewControllerDelegate, PDQuestionEditViewControllerDelegate>

@property (nonatomic, weak) IBOutlet PDPieceEditToolbar *toolbar;
@property (nonatomic, weak) IBOutlet PDPieceDiaryEditView *editView;

@property (nonatomic, retain) NSArray *dataArray;   // 记录每一个cell的数据
@property (nonatomic, assign) NSInteger currentIndex;  // 当前cell的索引

@end

@implementation PDPieceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.toolbar.delegate = self;
    self.editView.delegate = self;
    
    [self setupEditView:self.editView withIndex:self.currentIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyboardEevent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.editView.textView becomeFirstResponder];
    [self resetToolbarButtonsState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardEvent];
}

- (id)initWithDataArray:(NSArray *)dataArray currentIndex:(NSInteger)index
{
    self = [super init];
    if (self)
    {
        self.dataArray = dataArray;
        self.currentIndex = index;
    }
    
    return self;
}

- (void)setupEditViewWithIndex:(NSInteger)index
{
    [self setupEditView:self.editView withIndex:index];
}

- (void)setupEditView:(PDPieceDiaryEditView *)editView withIndex:(NSInteger)index
{
    PDPieceCellData *data = self.dataArray[index];
    [self setupEditView:editView withData:data];
}

- (void)setupEditView:(PDPieceDiaryEditView *)editView withData:(PDPieceCellData *)data
{    
    [editView setEditViewWithData:data];
}

- (void)addKeyboardEevent
{
    // 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeKeyboardEvent
{
    // 移除键盘事件监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.editView resetEditViewByHideKeyboard];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.editView convertRect:keyboardFrame fromView:self.view];
    
    [self.editView resetEditViewWithShowKeyboardFrame:keyboardFrame];
}

- (void)resetToolbarButtonsState
{
    // 根据当前索引来设置左右切换cell的按钮状态
    
    [self.toolbar setLeftBtnEnabled:YES];
    [self.toolbar setRightBtnEnabled:YES];
    
    if (self.currentIndex == 0)
    {
        // 第一个
        [self.toolbar setLeftBtnEnabled:NO];
    }
    else if (self.currentIndex == [self.dataArray count] - 1)
    {
        // 最后一个
        [self.toolbar setRightBtnEnabled:NO];
    }
}

- (void)changeEditViewWithType:(EditPieceCellChangeType)type
{
    // 添加两个临时的视图来展示滑动动画
    PDPieceDiaryEditView *slideInEditView = [self getSlideInEditViewWithType:type];
    PDPieceDiaryEditView *slideOutEditView = [self getSlideOutEditViewWithType:type];
    
    [self.view insertSubview:slideOutEditView aboveSubview:self.editView];
    [self.view addSubview:slideInEditView];
    
    [UIView animateWithDuration:0.5 animations:^(){
        slideOutEditView.frame = [self getSlideOutEditViewToFrameWithChangeType:type];
        slideInEditView.frame = self.editView.frame;
    }completion:^(BOOL finished)
     {
         [slideOutEditView removeFromSuperview];
         [slideInEditView removeFromSuperview];
     }];
    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(){
//        slideOutEditView.frame = [self getSlideOutEditViewToFrameWithChangeType:type];
//        slideInEditView.frame = self.editView.frame;
//    } completion:^(BOOL finished)
//     {
//         [slideOutEditView removeFromSuperview];
//         [slideInEditView removeFromSuperview];
//     }];
}

- (PDPieceDiaryEditView *)getSlideInEditViewWithType:(EditPieceCellChangeType)type
{
    // 滑入的view
    CGRect frame = (type == EditPieceCellChangeTypePrevious) ? [self getLeftEditViewFrame] : [self getRightEditViewFrame];
    return [self createEditViewWithFrame:frame cellData:self.dataArray[self.currentIndex]];
}

- (PDPieceDiaryEditView *)getSlideOutEditViewWithType:(EditPieceCellChangeType)type
{
    // 滑出的view
    CGRect frame = self.editView.frame;
    NSInteger oldIndex = (type == EditPieceCellChangeTypePrevious) ? self.currentIndex + 1 : self.currentIndex - 1;
    return [self createEditViewWithFrame:frame cellData:self.dataArray[oldIndex]];
}

- (PDPieceDiaryEditView *)createEditViewWithFrame:(CGRect)frame cellData:(PDPieceCellData *)data
{
    PDPieceDiaryEditView *editView = [[PDPieceDiaryEditView alloc] initWithFrame:frame];
    NSArray *nibArray = [[UINib nibWithNibName:@"PDPieceDiaryEditView" bundle:nil] instantiateWithOwner:editView options:nil];
    
    UIView *view = [nibArray firstObject];
    view.frame = editView.bounds;
    [editView addSubview:view];
    
    [self setupEditView:editView withData:data];
    return editView;
}

- (CGRect)getSlideOutEditViewToFrameWithChangeType:(EditPieceCellChangeType)type
{
    CGRect frame = (type == EditPieceCellChangeTypePrevious) ? [self getRightEditViewFrame] : [self getLeftEditViewFrame];
    return frame;
}

- (CGRect)getSlideInEditViewFrameWithChangeType:(EditPieceCellChangeType)type
{
    CGRect frame = (type == EditPieceCellChangeTypePrevious) ? [self getLeftEditViewFrame] : [self getRightEditViewFrame];
    return frame;
}

- (CGRect)getLeftEditViewFrame
{
    CGRect frame = self.editView.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect leftFrame = CGRectMake(-width, frame.origin.y, width, height);
    return leftFrame;
}

- (CGRect)getRightEditViewFrame
{
    CGRect frame = self.editView.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect rightFrame = CGRectMake(width, frame.origin.y, width, height);
    return rightFrame;
}


#pragma mark - PDPieceEditToolbarDelegate

- (void)returnPieceView
{
    [self setCurrentEditViewAnswerContent];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImagePicker
{
    PDImagePickerController *imagePickerController = [[PDImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    PDPieceCellData *data = self.dataArray[self.currentIndex];
    imagePickerController.date = data.date;
    imagePickerController.questionID = data.questionID;
    
    imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)previousPieceCellEditView
{
    [self setCurrentEditViewAnswerContent];
    self.currentIndex -= 1;
    [self resetToolbarButtonsState];
    [self setupEditViewWithIndex:self.currentIndex];
    [self changeEditViewWithType:EditPieceCellChangeTypePrevious];
}

- (void)nextPieceCellEditView
{
    [self setCurrentEditViewAnswerContent];
    self.currentIndex += 1;
    [self resetToolbarButtonsState];
    [self setupEditViewWithIndex:self.currentIndex];
    [self changeEditViewWithType:EditPieceCellChangeTypeNext];
}

- (void)setCurrentEditViewAnswerContent
{
    // 将当前页面编辑更改的内容保存到数据库
    NSString *answer = self.editView.textView.text;
    if (answer)
    {
        [self setAnswerWithContent:answer withIndex:self.currentIndex];
    }
}


- (void)setAnswerWithContent:(NSString *)content withIndex:(NSInteger)index
{
    // 根据索引设置问题内容
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        PDPieceCellData *data = self.dataArray[index];
        data.answer = content;
        
        PDDataManager *dataManager = [PDDataManager defaultManager];
        [dataManager setAnswerContentWithText:content questionID:data.questionID date:data.date];
    });
}

- (UIView *)inputAccessoryView
{
    // 键盘上的工具栏
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDPieceEditToolbar" owner:self.toolbar options:nil];
    UIView *toolbar = [nibViews firstObject];
    
    CGFloat toolbarHeight = ToolbarHeight;
    CGFloat toolbarWidth = CGRectGetWidth(self.view.frame);
    toolbar.frame = CGRectMake(0, 0, toolbarWidth, toolbarHeight);
    
    return toolbar;
}

#pragma mark - PDImagePickerControllerDelegate

- (void)imagePickerController:(PDImagePickerController *)imagePickerController pickFinishedWithPhotos:(NSArray *)photos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        NSDate *date = imagePickerController.date;
        NSInteger questionID = imagePickerController.questionID;
        
        NSMutableArray *photoDatas = [NSMutableArray array];
        for (NSInteger i = 0; i < [photos count]; i++)
        {
            PDPhotoData *photoData = [PDPhotoData new];
            photoData.date = date;
            photoData.questionID = questionID;
            photoData.image = photos[i];
            
            [photoDatas addObject:photoData];
        }
        
        // 选中的图片插入到数据库
        PDDataManager *dataManager = [PDDataManager defaultManager];
        [dataManager insertPhotosWithPhotoDatas:photoDatas];
        
        // 重新请求一次图片
        NSArray *datas = [dataManager getPhotoDatasWithDate:date questionID:questionID];
        PDPieceCellData *cellData = self.dataArray[self.currentIndex];
        cellData.photoDatas = datas;
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.editView setupImageViewWithPhotoDatas:datas];
        });
    });
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^(){
        [self resetToolbarButtonsState];
    }];
}

- (void)imagePickerControllerCancel:(PDImagePickerController *)imagePickerController
{
    // UIModalPresentationFormSheet的显示消失时不会调用viewWillAppear，所以通过加上回调来处理
    [self resetToolbarButtonsState];
}

#pragma mark - PDDisplayPhotoViewControllerDelegate



#pragma mark - PDPieceDiaryEditView

- (void)displayPhotos
{
    PDPieceCellData *cellData = self.dataArray[self.currentIndex];
//    NSInteger questionID = cellData.questionID;
//    NSDate *date = cellData.date;
//    
//    PDDataManager *dataManager = [PDDataManager defaultManager];
//    NSArray *photoDatas = [dataManager getPhotoDatasWithDate:date questionID:questionID];
    
    // mark 直接用看是否有问题。
    PDDisplayPhotoViewController *displayPhotoViewController = [[PDDisplayPhotoViewController alloc] initWithPhotoDatas:cellData.photoDatas];
    displayPhotoViewController.delegate = self;
    
    [self presentViewController:displayPhotoViewController animated:YES completion:nil];
}

- (void)showQuestionEditViewWithData:(PDPieceCellData *)data
{
    PDQuestionEditViewController *questionEditViewController = [[PDQuestionEditViewController alloc] initWithData:data delegate:self];
    
    questionEditViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    questionEditViewController.preferredContentSize = CGSizeMake(420, 260);
    [self presentViewController:questionEditViewController animated:YES completion:nil];
}


#pragma mark - PDQuestionEditViewControllerDelegate

- (void)setQuestionContentWithText:(NSString *)text
{
    [self.editView setQuestionContentWithText:text];
}

- (void)questionEditViewController:(PDQuestionEditViewController *)editViewController editQuestionContentText:(NSString *)text inDate:(NSDate *)date
{
    [editViewController dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        PDDataManager *dataManager = [PDDataManager defaultManager];
        [dataManager setQuetionContentWithNewContent:text oldContent:[editViewController getOldQuestionContent] inDate:date];
        
        self.dataArray = [dataManager getPieceViewCellDatasWithDate:date];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.editView setQuestionContentWithText:text];
        });
    });
}

@end








