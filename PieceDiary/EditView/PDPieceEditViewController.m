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
#import "PDPieceCellDataModel.h"
#import "PDDataManager.h"
#import "PDPhotoDataModel.h"

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
    PDPieceCellDataModel *dataModel = self.dataArray[index];
    [self setupEditView:editView withDataModel:dataModel];
}

- (void)setupEditView:(PDPieceDiaryEditView *)editView withDataModel:(PDPieceCellDataModel *)dataModel
{    
    [editView setEditViewWithDataModel:dataModel];
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
    return [self createEditViewWithFrame:frame dataModel:self.dataArray[self.currentIndex]];
}

- (PDPieceDiaryEditView *)getSlideOutEditViewWithType:(EditPieceCellChangeType)type
{
    // 滑出的view
    CGRect frame = self.editView.frame;
    NSInteger oldIndex = (type == EditPieceCellChangeTypePrevious) ? self.currentIndex + 1 : self.currentIndex - 1;
    return [self createEditViewWithFrame:frame dataModel:self.dataArray[oldIndex]];
}

- (PDPieceDiaryEditView *)createEditViewWithFrame:(CGRect)frame dataModel:(PDPieceCellDataModel *)dataModel
{
    PDPieceDiaryEditView *editView = [[PDPieceDiaryEditView alloc] initWithFrame:frame];
    NSArray *nibArray = [[UINib nibWithNibName:@"PDPieceDiaryEditView" bundle:nil] instantiateWithOwner:editView options:nil];
    
    UIView *view = [nibArray firstObject];
    view.frame = editView.bounds;
    [editView addSubview:view];
    
    [self setupEditView:editView withDataModel:dataModel];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImagePicker
{
    PDImagePickerController *imagePickerController = [[PDImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    PDPieceCellDataModel *dataModel = self.dataArray[self.currentIndex];
    imagePickerController.date = dataModel.date;
    imagePickerController.questionID = dataModel.questionID;
    
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
    PDPieceCellDataModel *dataModel = self.dataArray[index];
    dataModel.answer = content;
    
    PDDataManager *dataManager = [PDDataManager defaultManager];
    [dataManager setAnswerContentWithText:content questionID:dataModel.questionID date:dataModel.date];
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
    NSDate *date = imagePickerController.date;
    NSInteger questionID = imagePickerController.questionID;
    
    NSMutableArray *photoDataModels = [NSMutableArray array];
    for (NSInteger i = 0; i < [photos count]; i++)
    {
        PDPhotoDataModel *photoDataModel = [PDPhotoDataModel new];
        photoDataModel.date = date;
        photoDataModel.questionID = questionID;
        photoDataModel.image = photos[i];
        
        [photoDataModels addObject:photoDataModel];
    }
    
    // 选中的图片插入到数据库
    PDDataManager *dataManager = [PDDataManager defaultManager];
    [dataManager insertPhotosWithPhotoDataModels:photoDataModels];
    
    // 重新请求一次图片
    NSArray *dataModelsArray = [dataManager getPhotoDataModelsWithDate:date questionID:questionID];
    PDPieceCellDataModel *cellDataModel = self.dataArray[self.currentIndex];
    cellDataModel.photoDataModels = dataModelsArray;
    
    [self.editView setupImageViewWithPhotoDataModels:dataModelsArray];
    
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
    PDPieceCellDataModel *cellDataModel = self.dataArray[self.currentIndex];
    NSInteger questionID = cellDataModel.questionID;
    NSDate *date = cellDataModel.date;
    
    PDDataManager *dataManager = [PDDataManager defaultManager];
    NSArray *photoDataModels = [dataManager getPhotoDataModelsWithDate:date questionID:questionID];
    
    PDDisplayPhotoViewController *displayPhotoViewController = [[PDDisplayPhotoViewController alloc] initWithPhotoDataModels:photoDataModels];
    displayPhotoViewController.delegate = self;
    
    [self presentViewController:displayPhotoViewController animated:YES completion:nil];
}

- (void)showQuestionEditViewWithDataModel:(PDPieceCellDataModel *)dataModel
{
    PDQuestionEditViewController *questionEditViewController = [[PDQuestionEditViewController alloc] initWithDataModel:dataModel delegate:self];
    
    questionEditViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    questionEditViewController.preferredContentSize = CGSizeMake(420, 220);
    [self presentViewController:questionEditViewController animated:YES completion:nil];
}


#pragma mark - PDQuestionEditViewControllerDelegate

- (void)setQuestionContentWithText:(NSString *)text
{
    [self.editView setQuestionContentWithText:text];
}

- (void)questionEditViewController:(PDQuestionEditViewController *)editViewController editQuestionContentText:(NSString *)text inDate:(NSDate *)date
{
    PDDataManager *dataManager = [PDDataManager defaultManager];
    [dataManager setQuetionContentWithNewContent:text oldContent:[editViewController getOldQuestionContent] inDate:date];
    
    [editViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.dataArray = [dataManager getPieceViewDatasWithDate:date];
    [self.editView setQuestionContentWithText:text];
}

@end








