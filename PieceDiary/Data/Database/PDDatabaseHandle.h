//
//  PDDatabaseHandle.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DataBaseQueryResultNotFound     -999

@interface PDDatabaseHandle : NSObject

- (void)connect;

// 查询方法
- (NSInteger)getQuestionTemplateIDWithDate:(NSDate *)date;
- (NSInteger)getDefaultQuestionTemplateID;
- (NSArray *)getQuestionIDsWithTemplateID:(NSInteger)templateID;
- (NSString *)getQuestionWithID:(NSInteger)questionID;
- (NSString *)getAnswerWithQuestionID:(NSInteger)questionID date:(NSDate *)date;
- (NSInteger)getQuestionIDWithQuestionContent:(NSString *)content;
- (BOOL)hasQuestionContent:(NSString *)content;
- (NSString *)getTemplateQuestionIDNumberWithQuestionID:(NSInteger)questionID templateID:(NSInteger)templateID;
- (NSInteger)getTemplateQuestionIDIndexWithQuestionID:(NSInteger)questionID templateID:(NSInteger)templateID;
- (NSArray *)getTemplateQuestionIDsWithTemplateID:(NSInteger)templateID;
- (NSInteger)getTemplateIDWithQuestionIDs:(NSArray *)questionIDs;
- (BOOL)diaryTableHasDate:(NSDate *)date;
- (NSArray *)getPhotoDatasWithDate:(NSDate *)date questionID:(NSInteger)questionID;

// 更新方法
- (void)updateAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)updateDiaryQuestionTemplateID:(NSInteger)templateID date:(NSDate *)date;
- (void)updateAnswerQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date;

// 插入方法
- (void)insertAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)insertQuestionContentWithText:(NSString *)text;
- (void)insertQuestionTemplateWithQuestionIDs:(NSArray *)questionIDs;
- (void)insertDiaryDate:(NSDate *)date questionTemplateID:(NSInteger)templateID;
- (void)insertPhotoData:(NSData *)photoData inDate:(NSDate *)date questionID:(NSInteger)questionID;

@end
