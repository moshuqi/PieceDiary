//
//  PDDBHandler+Update.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler.h"

@interface PDDBHandler (Update)

- (void)updateAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)updateDiaryQuestionTemplateID:(NSInteger)templateID date:(NSDate *)date;
- (void)updateAnswerQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date;
- (void)updatePhotoQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date;
- (void)updateWeatherWithDate:(NSDate *)date weather:(NSString *)weather;
- (void)updateMoodWithDate:(NSDate *)date mood:(NSString *)mood;

@end
