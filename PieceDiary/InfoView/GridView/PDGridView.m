//
//  PDGridView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDGridView.h"
#import "PDGridCell.h"

#define PDGridCellIdentifier @"PDGridCellIdentifier"
#define PDGridCellInteritemSpacing   0
#define PDGridCellLineSpacing   0

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
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (PDGridCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PDGridCellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(collectionView.bounds) / 2;
    CGFloat height = CGRectGetHeight(collectionView.bounds) / 2;
    
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
