//
//  PDDBHandler+Insert.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler.h"

@interface PDDBHandler (Insert)

- (void)insertAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)insertQuestionContentWithText:(NSString *)text;
- (void)insertQuestionTemplateWithQuestionIDs:(NSArray *)questionIDs;
- (void)insertDiaryDate:(NSDate *)date questionTemplateID:(NSInteger)templateID;
- (void)insertPhotoData:(NSData *)photoData inDate:(NSDate *)date questionID:(NSInteger)questionID;
- (void)insertWeather:(NSString *)weather inDate:(NSDate *)date;
- (void)insertMood:(NSString *)mood inDate:(NSDate *)date;

@end
