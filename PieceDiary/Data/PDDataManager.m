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
        
        NSArray *photos = [self.dbHandle getPhotosWithQuestionID:questionID date:date];
        cellDataModel.photos = photos;
        
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

- (void)setQuetionContentWithText:(NSString *)text questionID:(NSInteger)questionID
{
    // 设置新的问题。数据库允许不同的问题ID对应相同的问题
    // 设置新的问题时，数据库直接添加新的问题ID，生成新的模板ID,然后修改原来答案对应的问题ID，和原来日期所对应的模板ID
    
}


@end
