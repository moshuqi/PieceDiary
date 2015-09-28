//
//  PDDataManager.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDataManager : NSObject

+ (instancetype)defaultManager;

- (NSArray *)getPieceViewDatasWithDate:(NSDate *)date;
- (void)setAnswerContentWithText:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)setQuetionContentWithNewContent:(NSString *)newContent oldContent:(NSString *)oldContent inDate:(NSDate *)date;

- (BOOL)exsistQuestionContent:(NSString *)content;  // 是否已存在这个问题
- (NSInteger)getQuestionIDWithQuestionContent:(NSString *)content;  // 通过问题内容获取问题ID
- (BOOL)exsistQuestionID:(NSInteger)questionID inDate:(NSDate *)date;   // date对应的日期中是否已存在该questionID
- (void)insertPhotosWithPhotoDataModels:(NSArray *)photoDatas;
- (NSArray *)getPhotoDataModelsWithDate:(NSDate *)date questionID:(NSInteger)questionID;

@end
