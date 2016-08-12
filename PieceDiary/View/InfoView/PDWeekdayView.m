//
//  PDWeekdayView.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/15.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDWeekdayView.h"
#import "PDWeekdayCell.h"

#define PDWeekdayCellIdentifier     @"PDWeekdayCellIdentifier"
#define PDWeekdayCellInteritemSpacing   1
#define PDWeekdayCellLineSpacing   1

#define PDWeekDayKey    @"PDWeekDayKey"
#define PDDayKey        @"PDDayKey"
#define PDCellStateKey  @"PDCellStateKey"

@interface PDWeekdayView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSDate *date;

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

- (void)awakeFromNib
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"PDWeekdayCell" bundle:nil] forCellWithReuseIdentifier:PDWeekdayCellIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = PDWeekdayCellInteritemSpacing;
    flowLayout.minimumLineSpacing = PDWeekdayCellLineSpacing;
    self.collectionView.collectionViewLayout = flowLayout;
    
    self.collectionView.backgroundColor = BackgroudGrayColor;
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = BackgroudGrayColor.CGColor;
}

- (void)setupWeekdayDataArrayWithDate:(NSDate *)date
{
    self.date = date;
    self.dataArray = [NSMutableArray array];
    
    NSArray *weekdays = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    NSInteger count = [weekdays count];
    
    NSDate *Sun = [date getSundayInThisWeek];
    for (NSInteger i = 0; i < count; i++)
    {
        NSString *weekdayStr = weekdays[i];
        
        NSDate *d = [Sun afterDays:i];
        NSInteger day = [d dayValue];
        NSString *dayStr = [NSString stringWithFormat:@"%ld", day];
        
        PDWeekdayCellState state = PDWeekdayCellStateNoDiary;
        if ([d dayValue] == [date dayValue])
        {
            state = PDWeekdayCellStateCurrentDay;
        }
        
        NSDictionary *dict = @{PDWeekDayKey : weekdayStr,
                               PDDayKey : dayStr,
                               PDCellStateKey : [NSNumber numberWithInteger:state]};
        [self.dataArray addObject:dict];
    }
}


- (void)setupWeekdayButtonsWithDate:(NSDate *)date
{
    [self setupWeekdayDataArrayWithDate:date];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSDate *sun = [self.date getSundayInThisWeek];
    NSDate *selectedDate = [sun afterDays:row];
    
    [self.delegate weekdaySelectedDate:selectedDate];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (PDWeekdayCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDWeekdayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PDWeekdayCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    NSString *weekday = [dict valueForKey:PDWeekDayKey];
    NSString *day = [dict valueForKey:PDDayKey];
    PDWeekdayCellState state = (PDWeekdayCellState)[[dict valueForKey:PDCellStateKey] integerValue];
    
    [cell setupWithWeekday:weekday day:day state:state];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.dataArray count];
    CGFloat width = (CGRectGetWidth(collectionView.bounds) - PDWeekdayCellInteritemSpacing * (count - 1)) / count;
    CGFloat height = CGRectGetHeight(collectionView.bounds);
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

@end
