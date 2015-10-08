//
//  PDRecordViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordViewController.h"
#import "PDSettingView.h"
#import "PDDataManager.h"

@interface PDRecordViewController () <PDSettingViewDelegate>

@property (nonatomic, retain) PDSettingView *recordView;
@property (nonatomic, retain) NSDate *date;

@end

@implementation PDRecordViewController

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        self.date = date;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PDSettingView" owner:self options:nil];
    self.recordView = [nibViews firstObject];
    self.recordView.frame = self.view.bounds;
    
    self.recordView.delegate = self;
    [self.recordView setupSettingViewWithDate:self.date];
    [self.view addSubview:self.recordView];
}

#pragma mark - PDSettingViewDelegate

- (void)settingDone:(id)sender
{
    NSString *mood = [self.recordView getMoodSettingString];
    NSString *weather = [self.recordView getWeatherSettingString];
    
    PDDataManager *dataManager = [PDDataManager defaultManager];
    [dataManager setupMoodWithDate:self.date mood:mood];
    [dataManager setupWeatherWithDate:self.date weather:weather];
    
    [self.delegate recordViewControllerDismiss:self];
}

@end
