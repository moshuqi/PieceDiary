//
//  PDTopBarView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDTopBarView.h"

@interface PDTopBarView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *returnBtn;

@end

@implementation PDTopBarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"PDTopBarView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.titleLabel.textColor = TitleTextBlackColor;
    
    [self.returnBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
}

- (void)setTitleWithText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (IBAction)touchedReturn:(id)sender
{
    [self.delegate infoTableViewReturn];
}

@end
