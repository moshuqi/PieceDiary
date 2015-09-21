//
//  PDImagePickerCell.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDImagePickerCell.h"

@interface PDImagePickerCell ()

@property (nonatomic, weak) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UIImageView *selectedMark;

@end

@implementation PDImagePickerCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentView bringSubviewToFront:self.selectedMark];
    self.selectedMark.hidden = YES;
}

- (void)setThumbnailWithImage:(UIImage *)image
{
    self.thumbnail.image = image;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.selectedMark.hidden = !selected;
}

@end
