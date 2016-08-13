//
//  PDDBHandler+Delete.m
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler+Delete.h"
#import "PDTimeFunc.h"

@implementation PDDBHandler (Delete)

- (void)deletePhotoWithPhotoID:(NSInteger)photoID
{
    // 删除图片
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = %@",DatabasePhotoTable, DatabasePhotoTablePhotoID, @(photoID)];
        BOOL result = [db executeUpdate:deleteSql];
        [self examDeleteWithResult:result];
    }];
}

- (void)deleteAnswerContentWithQuestionID:(NSInteger)questionID date:(NSDate *)date
{
    // 删除回答内容
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = %@ and date = \"%@\"",DatabaseAnswerTable, DatabaseQuestionTableQuestionID, @(questionID), [PDTimeFunc stringFromDate:date]];
        BOOL result = [db executeUpdate:deleteSql];
        [self examDeleteWithResult:result];
    }];
}

- (void)deleteWeatherWithDate:(NSDate *)date
{
    [self.queue inDatabase:^(FMDatabase *db) {
        // 删除天气
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where date = \"%@\"",DatabaseWeatherTable, [PDTimeFunc stringFromDate:date]];
        BOOL result = [db executeUpdate:deleteSql];
        [self examDeleteWithResult:result];
    }];
}

- (void)deleteMoodWithDate:(NSDate *)date
{
    [self.queue inDatabase:^(FMDatabase *db) {
        // 删除心情
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where date = \"%@\"",DatabaseMoodTable, [PDTimeFunc stringFromDate:date]];
        BOOL result = [db executeUpdate:deleteSql];
        [self examDeleteWithResult:result];
    }];
}

- (void)examDeleteWithResult:(BOOL)result
{
    NSString *str = [NSString stringWithFormat:@"数据库删除 %@", (result ? @"成功" : @"失败")];
    PDLog(@"%@", str);
}


@end
