//
//  PDDBHandler+Insert.m
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler+Insert.h"
#import "PDTimeFunc.h"

@implementation PDDBHandler (Insert)

- (void)insertAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[NSNumber numberWithInteger:questionID]];
        [arguments addObject:[PDTimeFunc stringFromDate:date]];
        [arguments addObject:text];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@, %@) values (?, ?, ?)", DatabaseAnswerTable, DatabaseQuestionTableQuestionID, DatabaseDate, DatabaseAnswerTableAnswerContent];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)insertQuestionContentWithText:(NSString *)text
{
    // 插入问题内容
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:text];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values (?)", DatabaseQuestionTable, DatabaseQuestionTableQuestionContent];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)insertQuestionTemplateWithQuestionIDs:(NSArray *)questionIDs
{
    // 插入新的模板
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        for (NSInteger i = 0; i < [questionIDs count]; i++)
        {
            [arguments addObject:questionIDs[i]];
        }
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (questionID1, questionID2, questionID3, questionID4, questionID5, questionID6, questionID7, questionID8) values (?, ?, ?, ?, ?, ?, ?, ?);", DatabaseQuestionTemplateTable];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)insertDiaryDate:(NSDate *)date questionTemplateID:(NSInteger)templateID
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[PDTimeFunc stringFromDate:date]];
        [arguments addObject:[NSNumber numberWithInteger:templateID]];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (?, ?)", DatabaseDiaryTable, DatabaseDate, DatabaseQuestionTemplateTableTemplateID];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)insertPhotoData:(NSData *)photoData inDate:(NSDate *)date questionID:(NSInteger)questionID
{
    // 插入图片
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[NSNumber numberWithInteger:questionID]];
        [arguments addObject:[PDTimeFunc stringFromDate:date]];
        [arguments addObject:photoData];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@, %@) values (?, ?, ?)", DatabasePhotoTable, DatabaseQuestionTableQuestionID, DatabaseDate, DatabasePhotoTablePhoto];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)insertWeather:(NSString *)weather inDate:(NSDate *)date
{
    // 插入天气
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[PDTimeFunc stringFromDate:date]];
        [arguments addObject:weather];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (?, ?)", DatabaseWeatherTable, DatabaseDate, DatabaseWeatherTableWeather];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)insertMood:(NSString *)mood inDate:(NSDate *)date
{
    // 插入心情
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[PDTimeFunc stringFromDate:date]];
        [arguments addObject:mood];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (?, ?)", DatabaseMoodTable, DatabaseDate, DatabaseMoodTableMood];
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        [self examInsertResult:result];
    }];
}

- (void)examInsertResult:(BOOL)res
{
    NSString *str = [NSString stringWithFormat:@"数据库插入 %@", (res ? @"成功" : @"失败")];
    PDLog(@"%@", str);
}

@end







