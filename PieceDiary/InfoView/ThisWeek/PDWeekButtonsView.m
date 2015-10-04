//
//  PDWeekButtonsView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDWeekButtonsView.h"

@interface PDWeekButtonsView ()

@property (nonatomic, weak) IBOutlet UIButton *SunBtn;
@property (nonatomic, weak) IBOutlet UIButton *MonBtn;
@property (nonatomic, weak) IBOutlet UIButton *TuesBtn;
@property (nonatomic, weak) IBOutlet UIButton *WedBtn;
@property (nonatomic, weak) IBOutlet UIButton *ThurBtn;
@property (nonatomic, weak) IBOutlet UIButton *FriBtn;
@property (nonatomic, weak) IBOutlet UIButton *SatBtn;

@end

@implementation PDWeekButtonsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDWeekButtonsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        
        [self setButtonsBorder];
    }
    
    return self;
}

- (void)setButtonsBorder
{
    NSArray *btnArray = @[self.SunBtn, self.MonBtn, self.TuesBtn, self.WedBtn, self.ThurBtn, self.FriBtn, self.SatBtn];
    for (NSInteger i = 0; i < [btnArray count]; i++)
    {
        UIButton *btn = btnArray[i];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    }
    
}

- (NSArray *)getWeekdayButtons
{
    NSArray *btnArray = @[self.SunBtn, self.MonBtn, self.TuesBtn, self.WedBtn, self.ThurBtn, self.FriBtn, self.SatBtn];
    return btnArray;
}

- (IBAction)buttonTouched:(id)sender
{
    NSLog(@"weekbuttons touched!");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
