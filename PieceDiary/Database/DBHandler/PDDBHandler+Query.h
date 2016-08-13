//
//  PDDBHandler+Query.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler.h"

@interface PDDBHandler (Query)

- (NSInteger)queryQuestionCount;
- (NSInteger)queryQuestionTemplateCount;
- (NSInteger)queryDefaultQuestionTemplateCount;

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

- (NSInteger)diaryQuantity;
- (NSInteger)editedGridQuantity;
- (NSInteger)questionQuantity;
- (NSInteger)photoQuantity;

- (NSArray *)getAllDiaryDate;
- (NSString *)getWeatherWithDate:(NSDate *)date;
- (NSString *)getMoodWithDate:(NSDate *)date;
- (BOOL)weatherExsistInDate:(NSDate *)date;
- (BOOL)moodExsistInDate:(NSDate *)date;

- (NSArray *)getAllEditedCellData;
- (NSArray *)getAllPhotoData;
- (NSArray *)getAllQuestionData;

@end
