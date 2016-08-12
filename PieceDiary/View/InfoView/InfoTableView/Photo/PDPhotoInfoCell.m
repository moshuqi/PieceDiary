//
//  PDPhotoInfoCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDPhotoInfoCell.h"

@interface PDPhotoInfoCell ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearMonthLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photo;

@end

@implementation PDPhotoInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentView bringSubviewToFront:self.dayLabel];
    [self.contentView bringSubviewToFront:self.yearMonthLabel];
}

- (void)setupWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day photo:(UIImage *)photo
{
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月", year, month];
    
    self.photo.image = photo;
}





@end
