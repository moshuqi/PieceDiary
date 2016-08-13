//
//  PDDBHandler+Update.m
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler+Update.h"
#import "PDTimeFunc.h"

@implementation PDDBHandler (Update)

- (void)updateAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date
{
    // 通过问题ID和日期，将答案设为新的值
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = \"%@\" where %@ = %@ and date = \"%@\"", DatabaseAnswerTable, DatabaseAnswerTableAnswerContent, text, DatabaseQuestionTableQuestionID, @(questionID), [PDTimeFunc stringFromDate:date]];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateWithResult:result];
    }];
}

- (void)updateDiaryQuestionTemplateID:(NSInteger)templateID date:(NSDate *)date
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = %@ where date = \"%@\"", DatabaseDiaryTable, DatabaseQuestionTemplateTableTemplateID, @(templateID), [PDTimeFunc stringFromDate:date]];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateWithResult:result];
    }];
}

- (void)updateAnswerQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date
{
    // 更新问题对应的ID
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = %@ where date = \"%@\" and %@ = %@", DatabaseAnswerTable, DatabaseQuestionTableQuestionID, @(newID), [PDTimeFunc stringFromDate:date], DatabaseQuestionTableQuestionID, @(oldID)];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateWithResult:result];
    }];
}

- (void)updatePhotoQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date
{
    // 更新图片对应的ID
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = %@ where date = \"%@\" and %@ = %@", DatabasePhotoTable, DatabaseQuestionTableQuestionID, @(newID), [PDTimeFunc stringFromDate:date], DatabaseQuestionTableQuestionID, @(oldID)];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateWithResult:result];
    }];
}

- (void)updateWeatherWithDate:(NSDate *)date weather:(NSString *)weather
{
    // 修改对应日期的天气
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = \"%@\" where date = \"%@\"", DatabaseWeatherTable, DatabaseWeatherTableWeather, weather, [PDTimeFunc stringFromDate:date]];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateWithResult:result];
    }];
}

- (void)updateMoodWithDate:(NSDate *)date mood:(NSString *)mood
{
    // 修改对应日期的心情
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = \"%@\" where date = \"%@\"", DatabaseMoodTable, DatabaseMoodTableMood, mood, [PDTimeFunc stringFromDate:date]];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateWithResult:result];
    }];
}

- (void)examUpdateWithResult:(BOOL)result
{
    NSString *str = [NSString stringWithFormat:@"数据库更新 %@", (result ? @"成功" : @"失败")];
    PDLog(@"%@", str);
}

@end
