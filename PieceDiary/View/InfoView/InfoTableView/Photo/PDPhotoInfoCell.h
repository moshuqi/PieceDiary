//
//  PDPhotoInfoCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDPhotoInfoCell : UICollectionViewCell

- (void)setupWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day photo:(UIImage *)photo;

@end
