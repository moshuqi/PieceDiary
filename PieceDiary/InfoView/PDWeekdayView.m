//
//  PDWeekdayView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDWeekdayView.h"
#import "PDWeekButtonsView.h"
#import "NSDate+PDDate.h"

@interface PDWeekdayView ()

@property (nonatomic, weak) IBOutlet PDWeekButtonsView *weekButtonsView;

@end

@implementation PDWeekdayView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDWeekdayView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        
    }
    
    return self;
}

- (void)setupWeekdayButtonsWithDate:(NSDate *)date
{
    NSDate *Sun = [date getSundayInThisWeek];
    NSArray *weekdayButtons = [self.weekButtonsView getWeekdayButtons];
    
    for (NSInteger i = 0; i < [weekdayButtons count]; i++)
    {
        NSDate *d = [Sun afterDays:i];
        UIButton *button = weekdayButtons[i];
        
        NSString *text = [NSString stringWithFormat:@"%ld", [d dayValue]];
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitle:text forState:UIControlStateHighlighted];
        
        if ([d dayValue] == [date dayValue])
        {
            // 当前日期显示不一样的颜色
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
