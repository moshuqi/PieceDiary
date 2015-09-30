//
//  PDGridInfoCell.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDGridInfoCell : UITableViewCell

- (void)setupWithDay:(NSInteger)day weekday:(NSInteger)weekday question:(NSString *)question answer:(NSString *)answer photo:(UIImage *)photo;

@end
