//
//  PDDataManager.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDDataManager.h"
#import "PDDatabaseHandle.h"
#import "PDPieceCellData.h"
#import "PDPhotoData.h"
#import <UIKit/UIKit.h>
#import "PDDiaryInfoSectionData.h"
#import "PDGridInfoSectionData.h"
#import "PDRecordWeather.h"
#import "PDRecordMood.h"

@interface PDDataManager ()

@property (nonatomic, retain) PDDatabaseHandle *dbHandle;

@end

@implementation PDDataManager

static PDDataManager *_instance;

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
        _instance = [[PDDataManager alloc] init];
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

- (NSArray *)getPieceViewCellDatasWithDate:(NSDate *)date
{
    // 根据日期获取每个cell相关的数据
    
    NSInteger questionTemplateID = [self.dbHandle getQuestionTemplateIDWithDate:date];
    NSArray *questionIDs = [self.dbHandle getQuestionIDsWithTemplateID:questionTemplateID];
    
    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger i = 0; i < [questionIDs count]; i++)
    {
        PDPieceCellData *cellData = [PDPieceCellData new];
        cellData.date = date;
        
        NSNumber *number = questionIDs[i];
        NSInteger questionID = [number integerValue];
        
        cellData.questionID = questionID;
        cellData.question = [self.dbHandle getQuestionWithID:questionID];
        cellData.answer = [self.dbHandle getAnswerWithQuestionID:questionID date:date];
        
        NSArray *photoDatas = [self.dbHandle getPhotoDatasWithDate:date questionID:questionID];
        cellData.photoDatas = photoDatas;
        
        [datas addObject:cellData];
    }
    
    return datas;
}

- (void)setAnswerContentWithText:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
{
    NSString *answer = [self.dbHandle getAnswerWithQuestionID:questionID date:date];
    BOOL bExsist = (answer != nil); // 原来是否存在内容
    if ([text length] < 1)
    {
        if (bExsist)
        {
            // text长度为0且原来存在内容，则此时做删除操作。
            [self.dbHandle deleteAnswerContentWithQuestionID:questionID date:date];
        }
        return;
    }
    
    if (bExsist)
    {
        // 已存在内容，则对数据库进行修改
        [self.dbHandle updateAnswerContentWith:text questionID:questionID date:date];
    }
    else
    {
        // 第一次编辑，则对数据库进行插入操作
        [self.dbHandle insertAnswerContentWith:text questionID:questionID date:date];
    }
    
    // 编辑过之后对应日期的日记要添加到数据库中
    if (![self.dbHandle diaryTableHasDate:date])
    {
        NSInteger defaultTemplateID = [self.dbHandle getDefaultQuestionTemplateID];
        [self.dbHandle insertDiaryDate:date questionTemplateID:defaultTemplateID];
    }
}

- (void)setQuetionContentWithNewContent:(NSString *)newContent oldContent:(NSString *)oldContent inDate:(NSDate *)date;
{
    // 设置新的问题。数据库问题ID和问题内容都为唯一值
    
    // 新问题的问题ID
    NSInteger newQuestionID = [self.dbHandle getQuestionIDWithQuestionContent:newContent];
    if (newQuestionID == DataBaseQueryResultNotFound)
    {
        [self.dbHandle insertQuestionContentWithText:newContent];
        newQuestionID = [self.dbHandle getQuestionIDWithQuestionContent:newContent];
    }
    
    // 旧值对应的索引
    NSInteger templateID = [self.dbHandle getQuestionTemplateIDWithDate:date];
    NSInteger oldQuestionID = [self.dbHandle getQuestionIDWithQuestionContent:oldContent];
    NSInteger index = [self.dbHandle getTemplateQuestionIDIndexWithQuestionID:oldQuestionID templateID:templateID];
    
    // 插入新的模板
    NSMutableArray *questionIDs = [NSMutableArray arrayWithArray:[self.dbHandle getQuestionIDsWithTemplateID:templateID]];
    [questionIDs setObject:[NSNumber numberWithInteger:newQuestionID] atIndexedSubscript:index];
    [self.dbHandle insertQuestionTemplateWithQuestionIDs:questionIDs];
    
    // 获取新模板的模板ID
    NSInteger newTemplateID = [self.dbHandle getTemplateIDWithQuestionIDs:questionIDs];
    if ([self.dbHandle diaryTableHasDate:date])
    {
        [self.dbHandle updateDiaryQuestionTemplateID:newTemplateID date:date];
    }
    else
    {
        [self.dbHandle insertDiaryDate:date questionTemplateID:newTemplateID];
    }
    
    // 对应答案的问题ID更新
    [self.dbHandle updateAnswerQuestionIDWithOldID:oldQuestionID newID:newQuestionID date:date];
    
    // 对应图片的问题ID更新
    [self.dbHandle updatePhotoQuestionIDWithOldID:oldQuestionID newID:newQuestionID date:date];
}

- (BOOL)exsistQuestionContent:(NSString *)content
{
    return [self.dbHandle hasQuestionContent:content];
}

- (NSInteger)getQuestionIDWithQuestionContent:(NSString *)content
{
    return [self.dbHandle getQuestionIDWithQuestionContent:content];
}

- (BOOL)exsistQuestionID:(NSInteger)questionID inDate:(NSDate *)date
{
    NSInteger templateID = [self.dbHandle getQuestionTemplateIDWithDate:date];
    NSArray *questionIDs = [self.dbHandle getQuestionIDsWithTemplateID:templateID];
    
    for (NSInteger i = 0; i < [questionIDs count]; i++)
    {
        NSInteger quesID = [questionIDs[i] integerValue];
        if (questionID == quesID)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)insertPhotosWithPhotoDatas:(NSArray *)photoDatas
{
    for (NSInteger i = 0; i < [photoDatas count]; i++)
    {
        PDPhotoData *dataModel = photoDatas[i];
        
        UIImage *image = dataModel.image;
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        NSDate *date = dataModel.date;
        NSInteger questionID = dataModel.questionID;
        
        [self.dbHandle insertPhotoData:imageData inDate:date questionID:questionID];
    }
    
    // 编辑过之后对应日期的日记要添加到数据库中
    PDPhotoData *model = [photoDatas firstObject];
    NSDate *date = model.date;
    if (![self.dbHandle diaryTableHasDate:date])
    {
        NSInteger defaultTemplateID = [self.dbHandle getDefaultQuestionTemplateID];
        [self.dbHandle insertDiaryDate:date questionTemplateID:defaultTemplateID];
    }
}

- (NSArray *)getPhotoDatasWithDate:(NSDate *)date questionID:(NSInteger)questionID
{
    NSArray *photoDatas = [self.dbHandle getPhotoDatasWithDate:date questionID:questionID];
    return photoDatas;
}

- (void)deletePhotoWithPhotoID:(NSInteger)photoID
{
    [self.dbHandle deletePhotoWithPhotoID:photoID];
}

- (NSInteger)getDiaryQuantity
{
    return [self.dbHandle diaryQuantity];
}

- (NSInteger)getEditedGridQuantity
{
    return [self.dbHandle editedGridQuantity];
}

- (NSInteger)getQuestionQuantity
{
    return [self.dbHandle questionQuantity];
}

- (NSInteger)getPhotoQuantity
{
    return [self.dbHandle photoQuantity];
}

- (NSArray *)getDiaryInfoData
{
    NSMutableArray *diaryInfoData = [NSMutableArray array];
    NSArray *dateArray = [self.dbHandle getAllDiaryDate];
    
    PDDiaryInfoSectionData *currentSectionModel = nil;
    for (NSInteger i = 0; i < [dateArray count]; i++)
    {
        NSDate *date = dateArray[i];
        NSInteger year = [date yearValue];
        NSInteger month  = [date monthValue];
        
        if (!currentSectionModel)
        {
            currentSectionModel = [PDDiaryInfoSectionData new];
            currentSectionModel.year = year;
            currentSectionModel.month = month;
            currentSectionModel.cellDatas = [NSMutableArray array];
        }
        
        PDDiaryInfoCellData *cellData = [PDDiaryInfoCellData new];
        cellData.date = date;
        cellData.mood = [self.dbHandle getMoodWithDate:date];
        cellData.weather = [self.dbHandle getWeatherWithDate:date];
        
        if ((year != currentSectionModel.year) || (month != currentSectionModel.month))
        {
            // 不是同年同月，重新建立一个section，原先的section添加到数组中
            [diaryInfoData addObject:currentSectionModel];
            
            currentSectionModel = [PDDiaryInfoSectionData new];
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
    
    PDGridInfoSectionData *currentSectionModel = nil;
    for (NSInteger i = 0; i < [editedCellDataArray count]; i++)
    {
        PDGridInfoCellData *cellDataModel = editedCellDataArray[i];
        NSDate *date = cellDataModel.date;
        
        NSInteger year = [date yearValue];
        NSInteger month  = [date monthValue];
        
        if (!currentSectionModel)
        {
            currentSectionModel = [PDGridInfoSectionData new];
            currentSectionModel.year = year;
            currentSectionModel.month = month;
            currentSectionModel.cellDatas = [NSMutableArray array];
        }
        
        if ((year != currentSectionModel.year) || (month != currentSectionModel.month))
        {
            // 不是同年同月，重新建立一个section，原先的section添加到数组中
            [dataArray addObject:currentSectionModel];
            
            currentSectionModel = [PDGridInfoSectionData new];
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

- (NSArray *)getPhotoInfoData
{
    return [self.dbHandle getAllPhotoData];
}

- (NSArray *)getQuestionInfoData
{
    return [self.dbHandle getAllQuestionData];
}

- (NSString *)getWeahterStringWithDate:(NSDate *)date
{
    return [self.dbHandle getWeatherWithDate:date];
}

- (NSString *)getMoodStringWithDate:(NSDate *)date
{
    return [self.dbHandle getMoodWithDate:date];
}

- (void)setupWeatherWithDate:(NSDate *)date weather:(NSString *)weather
{
    if (!weather || ([weather length] < 1))
    {
        // weather为nil或长度为0，做数据库的删除操作。
        [self.dbHandle deleteWeatherWithDate:date];
    }
    else
    {
        // weather不为空，判断对应日期是否已存在数据库中，若存在则做更新操作，否则进行插入操作
        if ([self.dbHandle weatherExsistInDate:date])
        {
            [self.dbHandle updateWeatherWithDate:date weather:weather];
        }
        else
        {
            [self.dbHandle insertWeather:weather inDate:date];
        }
    }
}

- (void)setupMoodWithDate:(NSDate *)date mood:(NSString *)mood
{
    if (!mood || ([mood length] < 1))
    {
        // mood为nil或长度为0，做数据库的删除操作。
        [self.dbHandle deleteMoodWithDate:date];
    }
    else
    {
        // mood不为空，判断对应日期是否已存在数据库中，若存在则做更新操作，否则进行插入操作
        if ([self.dbHandle moodExsistInDate:date])
        {
            [self.dbHandle updateMoodWithDate:date mood:mood];
        }
        else
        {
            [self.dbHandle insertMood:mood inDate:date];
        }
    }
}


- (UIImage *)getWeatherImageWithDate:(NSDate *)date
{
    // 天气的图标，若数据库存在记录，则返回对应选中的图标，否则返回默认图标
    
    NSString *weatherStr = [self getWeahterStringWithDate:date];
    if (!weatherStr || ([weatherStr length] < 1))
    {
        return [PDRecordWeather getMoodDefaultImage];
    }
    
    return [PDRecordWeather getWeatherImageWithWeatherString:weatherStr];
}

- (UIImage *)getMoodImageWithDate:(NSDate *)date
{
    // 心情的图标，若数据库存在记录，则返回对应选中的图标，否则返回默认图标
    
    NSString *moodStr = [self getMoodStringWithDate:date];
    if (!moodStr || ([moodStr length] < 1))
    {
        return [PDRecordMood getMoodDefaultImage];
    }
    
    return [PDRecordMood getMoodImageWithMoodString:moodStr];
}

@end
