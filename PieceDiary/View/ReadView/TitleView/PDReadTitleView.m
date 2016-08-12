//
//  PDReadTitleView.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDReadTitleView.h"

@interface PDReadTitleView ()

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation PDReadTitleView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDReadTitleView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

- (void)setupLabelWithDate:(NSDate *)date
{
    NSInteger year = [date yearValue];
    NSInteger month = [date monthValue];
    NSInteger day = [date dayValue];
    
    NSString *str = [NSString stringWithFormat:@"%@年%@月%@日", @(year), @(month), @(day)];
    self.dateLabel.text = str;
}

@end
