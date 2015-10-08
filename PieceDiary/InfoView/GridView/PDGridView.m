//
//  PDGridView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDGridView.h"
#import "PDGridCell.h"
#import "PDDataManager.h"
#import "PDDefine.h"

#define PDGridCellIdentifier @"PDGridCellIdentifier"
#define PDGridCellInteritemSpacing   1
#define PDGridCellLineSpacing   1

@interface PDGridView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *gridCollection;

@end

@implementation PDGridView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDGridView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
//    [self.gridCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PDGridCellIdentifier];
    [self.gridCollection registerNib:[UINib nibWithNibName:@"PDGridCell" bundle:nil] forCellWithReuseIdentifier:PDGridCellIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = PDGridCellInteritemSpacing;
    flowLayout.minimumLineSpacing = PDGridCellLineSpacing;
    
    self.gridCollection.collectionViewLayout = flowLayout;
    self.gridCollection.backgroundColor = BackgroudGrayColor;
    
//    self.gridCollection.layer.borderWidth = 1;
//    self.gridCollection.layer.borderColor = BackgroudGrayColor.CGColor;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDGridCell *cell = (PDGridCell *)[collectionView cellForItemAtIndexPath:indexPath];
    PDGridCellType type = cell.type;
    
    [self showTableViewWithType:type];
}

- (void)showTableViewWithType:(PDGridCellType)type
{
    switch (type) {
        case PDGridCellTypeDiary:
            [self.delegate showDiaryTableView];
            break;
            
        case PDGridCellTypeCrid:
            [self.delegate showGridTableView];
            break;
            
        case PDGridCellTypeQuestion:
            [self.delegate showQuestionTableView];
            break;
            
        case PDGridCellTypePhoto:
            [self.delegate showPhotoTableView];
            break;
            
        default:
            break;
    }

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (PDGridCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PDGridCellIdentifier forIndexPath:indexPath];
    static PDGridCellType typeArray[] = {PDGridCellTypeDiary, PDGridCellTypeCrid, PDGridCellTypeQuestion, PDGridCellTypePhoto};
    [self setupGridCell:cell withType:typeArray[indexPath.row]];

    return cell;
}

- (void)setupGridCell:(PDGridCell *)cell withType:(PDGridCellType)type
{
    cell.type = type;
    [cell setCellTitleWithText:[self getLabelContentWithType:type]];
    [cell setQuantityWithNumber:[self getQuantityWithType:type]];
}

- (NSString *)getLabelContentWithType:(PDGridCellType)type
{
    NSString *content = @"";
    switch (type) {
        case PDGridCellTypeDiary:
            content = @"日记";
            break;
            
        case PDGridCellTypeCrid:
            content = @"格子";
            break;
            
        case PDGridCellTypeQuestion:
            content = @"问题";
            break;
            
        case PDGridCellTypePhoto:
            content = @"照片";
            break;
            
        default:
            break;
    }
    
    return content;
}

- (NSInteger)getQuantityWithType:(PDGridCellType)type
{
    // 获取数量
    NSInteger quantity = 0;
    PDDataManager *dataManager = [PDDataManager defaultManager];
    
    switch (type) {
        case PDGridCellTypeDiary:
            quantity = [dataManager getDiaryQuantity];
            break;
            
        case PDGridCellTypeCrid:
            quantity = [dataManager getEditedGridQuantity];
            break;
            
        case PDGridCellTypeQuestion:
            quantity = [dataManager getQuestionQuantity];
            break;
            
        case PDGridCellTypePhoto:
            quantity = [dataManager getPhotoQuantity];
            break;
            
        default:
            break;
    }
    
    return quantity;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(collectionView.bounds) - PDGridCellInteritemSpacing)/ 2;
    CGFloat height = (CGRectGetHeight(collectionView.bounds) - PDGridCellLineSpacing) / 2;
    
    CGSize size = CGSizeMake(width, height);
    return size;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
