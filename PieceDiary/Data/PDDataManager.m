//
//  PDDataManager.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDDataManager.h"
#import "PDDatabaseHandle.h"
#import "PDPieceCellDataModel.h"
#import "PDPhotoDataModel.h"
#import <UIKit/UIKit.h>

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

- (NSArray *)getPieceViewDatasWithDate:(NSDate *)date
{
    // 根据日期获取每个cell相关的数据
    
    NSInteger questionTemplateID = [self.dbHandle getQuestionTemplateIDWithDate:date];
    NSArray *questionIDs = [self.dbHandle getQuestionIDsWithTemplateID:questionTemplateID];
    
    NSMutableArray *dataModels = [NSMutableArray array];
    for (NSInteger i = 0; i < [questionIDs count]; i++)
    {
        PDPieceCellDataModel *cellDataModel = [PDPieceCellDataModel new];
        cellDataModel.date = date;
        
        NSNumber *number = questionIDs[i];
        NSInteger questionID = [number integerValue];
        
        cellDataModel.questionID = questionID;
        cellDataModel.question = [self.dbHandle getQuestionWithID:questionID];
        cellDataModel.answer = [self.dbHandle getAnswerWithQuestionID:questionID date:date];
        
        NSArray *photoDatas = [self.dbHandle getPhotoDatasWithDate:date questionID:questionID];
        NSMutableArray *photoDataModels = [NSMutableArray array];
        for (NSInteger i = 0; i < [photoDatas count]; i++)
        {
            PDPhotoDataModel *photoDataModel = [PDPhotoDataModel new];
            photoDataModel.questionID = questionID;
            photoDataModel.date = date;
            
            NSDictionary *dict = photoDatas[i];
            id key = [[dict allKeys] firstObject];
            NSInteger photoID = [key integerValue];
            photoDataModel.photoID = photoID;
            
            NSData *photoData = [dict valueForKey:key];
            UIImage *image = [UIImage imageWithData:photoData];
            photoDataModel.image = image;
            
            [photoDataModels addObject:photoDataModel];
        }
        
        cellDataModel.photoDataModels = photoDataModels;
        
        [dataModels addObject:cellDataModel];
    }
    
    return dataModels;
}

- (void)setAnswerContentWithText:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
{
    NSString *answer = [self.dbHandle getAnswerWithQuestionID:questionID date:date];
    if (answer)
    {
        // 已存在内容，则对数据库进行修改
        [self.dbHandle updateAnswerContentWith:text questionID:questionID date:date];
    }
    else
    {
        // 第一次编辑，则对数据库进行插入操作
        [self.dbHandle insertAnswerContentWith:text questionID:questionID date:date];
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

- (void)insertPhotosWithPhotoDataModels:(NSArray *)photoDatas
{
    for (NSInteger i = 0; i < [photoDatas count]; i++)
    {
        PDPhotoDataModel *dataModel = photoDatas[i];
        
        UIImage *image = dataModel.image;
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSDate *date = dataModel.date;
        NSInteger questionID = dataModel.questionID;
        
        [self.dbHandle insertPhotoData:imageData inDate:date questionID:questionID];
    }
}

- (NSArray *)getPhotoDataModelsWithDate:(NSDate *)date questionID:(NSInteger)questionID
{
    NSArray *dicts = [self.dbHandle getPhotoDatasWithDate:date questionID:questionID];
    
    NSMutableArray *photoDataModels = [NSMutableArray array];
    for (NSInteger i = 0; i < [dicts count]; i++)
    {
        NSDictionary *dict = dicts[i];
        id key = [[dict allKeys] firstObject];
        NSInteger photoID = [key integerValue];
        
        NSData *photoData = [dict valueForKey:key];
        UIImage *image = [UIImage imageWithData:photoData];
        
        PDPhotoDataModel *dataModel = [PDPhotoDataModel new];
        dataModel.image = image;
        dataModel.date = date;
        dataModel.questionID = questionID;
        dataModel.photoID = photoID;
        
        [photoDataModels addObject:dataModel];
    }
    
    return photoDataModels;
}

@end
