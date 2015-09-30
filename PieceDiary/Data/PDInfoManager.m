//
//  PDInfoManager.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDInfoManager.h"
#import "PDDatabaseHandle.h"
#import "PDDiaryInfoSectionDataModel.h"
#import "PDGridInfoSectionDataModel.h"

@interface PDInfoManager ()

@property (nonatomic, retain) PDDatabaseHandle *dbHandle;

@end

@implementation PDInfoManager

static PDInfoManager *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PDInfoManager alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dbHandle = [PDDatabaseHandle new];
        [self.dbHandle connect];
    }
    
    return self;
}

- (NSArray *)getDiaryInfoData
{
    NSMutableArray *diaryInfoData = [NSMutableArray array];
    NSArray *dateArray = [self.dbHandle getAllDiaryDateForInfo];
    
    PDDiaryInfoSectionDataModel *currentSectionModel = nil;
    for (NSInteger i = 0; i < [dateArray count]; i++)
    {
        NSDate *date = dateArray[i];
        NSInteger year = [PDInfoManager getYearValueWithDate:date];
        NSInteger month  = [PDInfoManager getMonthValueWithDate:date];
        
        if (!currentSectionModel)
        {
            currentSectionModel = [PDDiaryInfoSectionDataModel new];
            currentSectionModel.year = year;
            currentSectionModel.month = month;
            currentSectionModel.cellDatas = [NSMutableArray array];
        }
        
        PDDiaryInfoCellDataModel *cellData = [PDDiaryInfoCellDataModel new];
        cellData.date = date;
        cellData.mood = [self.dbHandle getMoodWithDate:date];
        cellData.weather = [self.dbHandle getWeatherWithDate:date];
        
        if ((year != currentSectionModel.year) || (month != currentSectionModel.month))
        {
            // 不是同年同月，重新建立一个section，原先的section添加到数组中
            [diaryInfoData addObject:currentSectionModel];
            
            currentSectionModel = [PDDiaryInfoSectionDataModel new];
            currentSectionModel.year = year;
            currentSectionModel.month = month;
            currentSectionModel.cellDatas = [NSMutableArray array];
        }
        
        [currentSectionModel.cellDatas addObject:cellData];
        
        // 遍历完后将最后一个section添加到数组中
        if (i == [dateArray count] - 1)
        {
            [diaryInfoData addObject:currentSectionModel];
        }
    }
    
    return diaryInfoData;
}

- (NSArray *)getGridInfoData
{
    NSArray *editedCellDataArray = [self.dbHandle getAllEditedCellData];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    PDGridInfoSectionDataModel *currentSectionModel = nil;
    for (NSInteger i = 0; i < [editedCellDataArray count]; i++)
    {
        PDGridInfoCellDataModel *cellDataModel = editedCellDataArray[i];
        NSDate *date = cellDataModel.date;
        
        NSInteger year = [PDInfoManager getYearValueWithDate:date];
        NSInteger month  = [PDInfoManager getMonthValueWithDate:date];
        
        if (!currentSectionModel)
        {
            currentSectionModel = [PDGridInfoSectionDataModel new];
            currentSectionModel.year = year;
            currentSectionModel.month = month;
            currentSectionModel.cellDatas = [NSMutableArray array];
        }
        
        if ((year != currentSectionModel.year) || (month != currentSectionModel.month))
        {
            // 不是同年同月，重新建立一个section，原先的section添加到数组中
            [dataArray addObject:currentSectionModel];
            
            currentSectionModel = [PDGridInfoSectionDataModel new];
            currentSectionModel.year = year;
            currentSectionModel.month = month;
            currentSectionModel.cellDatas = [NSMutableArray array];
        }
        
        [currentSectionModel.cellDatas addObject:cellDataModel];
        
        // 遍历完后将最后一个section添加到数组中
        if (i == [editedCellDataArray count] - 1)
        {
            [dataArray addObject:currentSectionModel];
        }
    }
    
    return dataArray;
}

+ (NSInteger)getYearValueWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger year = components.year;
    return year;
}

+ (NSInteger)getMonthValueWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger month = components.month;
    return month;
}

+ (NSInteger)getWeekdayValueWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    
    NSInteger weekday = components.weekday;
    return weekday;
}

+ (NSInteger)getDayValueWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger day = components.day;
    return day;
}

@end
