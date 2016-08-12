//
//  PDQuestionDetailCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDQuestionDetailCell : UITableViewCell

- (void)setupWithDay:(NSInteger)day weekday:(NSInteger)weekday answer:(NSString *)answer photo:(UIImage *)photo;

@end
