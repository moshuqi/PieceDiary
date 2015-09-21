//
//  PDPieceCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/10.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPieceCellDataModel.h"
#import "PDDateCellView.h"

@interface PDPieceCell : UICollectionViewCell

@property (nonatomic, retain) NSArray *icons;
@property (nonatomic, retain) PDDateCellView *dateCellView;

- (void)setupWithDataModel:(PDPieceCellDataModel *)dataModel;
- (void)setDateHidden:(BOOL)hidden;

@end
