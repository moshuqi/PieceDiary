//
//  PDDatabaseHandle.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDatabaseHandle : NSObject

- (void)connect;

// 查询方法
- (NSInteger)getQuestionTemplateIDWithDate:(NSDate *)date;
- (NSInteger)getDefaultQuestionTemplateID;
- (NSArray *)getQuestionIDsWithTemplateID:(NSInteger)templateID;
- (NSString *)getQuestionWithID:(NSInteger)questionID;
- (NSString *)getAnswerWithQuestionID:(NSInteger)questionID date:(NSDate *)date;
- (NSArray *)getPhotosWithQuestionID:(NSInteger)questionID date:(NSDate *)date;
- (NSString *)getAnswerContentWithQuestionID:(NSInteger)questionID date:(NSDate *)date;

// 更新方法
- (void)updateAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;

// 插入方法
- (void)insertAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)insertQuestionContentWithText:(NSString *)text;

@end
