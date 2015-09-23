//
//  PDPieceDiaryView.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDPieceDiaryView;

@protocol PDPieceDiaryViewDelegate <NSObject>

- (void)pieceDiaryView:(PDPieceDiaryView *)pieceDiaryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)enterEditFromCell:(UICollectionViewCell *)cell dataArrayIndex:(NSInteger)index;
- (void)enterRecordViewWithDate:(NSDate *)date;

@end

@interface PDPieceDiaryView : UIView

@property (nonatomic, assign) id<PDPieceDiaryViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UICollectionView *pieceCollectionView;
@property (nonatomic, retain) NSArray *cellDataArray;

- (void)setCurrentDateWithDate:(NSDate *)date;

@end
