//
//  PDDateCell.h
//  PieceDiary
//
//  Created by HD on 16/8/12.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDDateCell : UICollectionViewCell

- (void)setupWithDate:(NSDate *)date weatherIcon:(UIImage *)weatherIcon moodIcon:(UIImage *)moodIcon;

@end
