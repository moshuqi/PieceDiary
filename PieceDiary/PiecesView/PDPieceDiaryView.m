//
//  PDPieceDiaryView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDPieceDiaryView.h"
#import "PDDateCellView.h"
#import "PDPieceCell.h"

#define PiecesCollectionIdentifier  @"PiecesCollectionIdentifier"

#define kDateCellHeight     156
#define kToolBarHeight      44

#define kMinimumInteritemSpacing    0
#define kMinimumLineSpacing  1

@interface PDPieceDiaryView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *pieceCollectionView;
@property (nonatomic, retain) PDDateCellView *dateCell;

@end

@implementation PDPieceDiaryView

- (void)awakeFromNib
{
    // Initialization code
    
    [self initPiecesCollectionView];
}

- (void)initPiecesCollectionView
{
//    [self.pieceCollectionView registerClass:[PDPieceCell class] forCellWithReuseIdentifier:PiecesCollectionIdentifier];
    [self.pieceCollectionView registerNib:[UINib nibWithNibName:@"PDPieceCell" bundle:nil] forCellWithReuseIdentifier:PiecesCollectionIdentifier];  // xib自定义cell需要用这种方式注册
    
    [self addSubview:self.pieceCollectionView];
}

- (BOOL)isLandscape
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return NO;
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft ||
             orientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    
    NSLog(@"判断横竖屏有误。");
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self resetLayout];
}

- (void)resetLayout
{
    [self.pieceCollectionView setCollectionViewLayout:[self getCollectionViewFlowLayout] animated:NO];  // 这个地方设为NO会导致reloadData刷新无效。
    [self.pieceCollectionView reloadData];
}

- (UICollectionViewFlowLayout *)getCollectionViewFlowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    flowLayout.minimumLineSpacing = kMinimumLineSpacing;
    
    return flowLayout;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (PDPieceCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDPieceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PiecesCollectionIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    // 横竖屏时显示日期的cell
    if (([self isLandscape] && (indexPath.row == 4)) ||
        (![self isLandscape] && (indexPath.row == 0)))
    {
        if (self.dateCell)
        {
            [self.dateCell removeFromSuperview];
        }
        else
        {
            NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDDateCellView" owner:self options:nil];
            self.dateCell = [nibViews objectAtIndex:0];
        }
        
        self.dateCell.frame = cell.contentView.bounds;
        [cell.contentView addSubview:self.dateCell];
        
        NSDate *date = [NSDate date];
        [self.dateCell setDateLabelsWithDate:date];
        
        return cell;
    }
    
    UIImage *image1 = [UIImage imageNamed:@"1.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"1.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"1.jpg"];
    UIImage *image4 = [UIImage imageNamed:@"1.jpg"];
    UIImage *image5 = [UIImage imageNamed:@"1.jpg"];
    
    NSArray *images = @[image1, image2, image3, image4, image5];
    cell.icons = images;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 横屏时为3行3列，日期在正中间方格；竖屏时为4行2列，日期显示在顶端独占一行
    CGSize size = CGSizeZero;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    if ([self isLandscape])
    {
        size = CGSizeMake(width / 3, (height - kToolBarHeight) / 3);
    }
    else
    {
        if (indexPath.row == 0)
        {
            size = CGSizeMake(width, kDateCellHeight);
        }
        else
        {
            size = CGSizeMake(width / 2, (height - kToolBarHeight - kDateCellHeight) / 4);
        }
    }
    
    return size;
}

@end
