//
//  PDDiaryInfoCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDDiaryInfoCell : UITableViewCell

- (void)setupWithDay:(NSInteger)day weekday:(NSInteger)weekday weatherImage:(UIImage *)weatherImage moodImage:(UIImage *)moodImage;

@end
