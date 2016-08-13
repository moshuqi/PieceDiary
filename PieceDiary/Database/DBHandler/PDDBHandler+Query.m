//
//  PDDBHandler+Query.m
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler+Query.h"
#import "PDPhotoData.h"
#import "PDGridInfoCellData.h"
#import "PDQuestionInfoCellData.h"
#import "PDGridInfoSectionData.h"
#import "PDTimeFunc.h"

#define DataBaseQueryResultNotFound -999

@implementation PDDBHandler (Query)

- (NSInteger)queryQuestionCount
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseQuestionTable];
    __block NSInteger count = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet * res = [db executeQuery:sql];
        
        count = 0;
        if ([res next])
        {
            count = [res intForColumnIndex:0];
        }
        
        [res close];
    }];
    
    return count;
}

- (NSInteger)queryQuestionTemplateCount
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseQuestionTemplateTable];
    __block NSInteger count = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet * res = [db executeQuery:sql];
        
        count = 0;
        if ([res next])
        {
            count = [res intForColumnIndex:0];
        }
        
        [res close];
    }];
    
    return count;
}

- (NSInteger)queryDefaultQuestionTemplateCount
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseDefaultQuestionTemplateTable];
    __block NSInteger count = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet * res = [db executeQuery:sql];
        
        count = 0;
        if ([res next])
        {
            count = [res intForColumnIndex:0];
        }
        
        [res close];
    }];
    
    return count;
}

- (NSInteger)getQuestionTemplateIDWithDate:(NSDate *)date
{
    // 通过日期获取模板
    __block NSInteger templateID;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [PDTimeFunc stringFromDate:date]];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        // 查询日期是否有对应的模板，若有，则说明该日期进行过编辑；否则使用对应模板，该日期为第一次进行编辑
        if ([queryRes next])
        {
            templateID = (NSInteger)[queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
        }
        else
        {
            templateID = [self getDefaultQuestionTemplateID];
        }
        
        [queryRes close];
    }];
    
    return  templateID;
}

- (NSInteger)getDefaultQuestionTemplateID
{
    // 获取默认模板
    __block NSInteger templateID = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@", DatabaseQuestionTemplateTableTemplateID, DatabaseDefaultQuestionTemplateTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            templateID = (NSInteger)[queryRes intForColumnIndex:0];
        }
        else
        {
            PDLog(@"默认模板ID获取有误！");
        }
        
        [queryRes close];
    }];
    
    return templateID;
}

- (NSArray *)getQuestionIDsWithTemplateID:(NSInteger)templateID
{
    // 根据模板ID获取对应所有问题的ID
    __block NSArray *questionIDs = nil;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@ = %@", DatabaseQuestionTemplateTable, DatabaseQuestionTemplateTableTemplateID, @(templateID)];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            NSInteger question1 = [queryRes intForColumn:@"questionID1"];
            NSInteger question2 = [queryRes intForColumn:@"questionID2"];
            NSInteger question3 = [queryRes intForColumn:@"questionID3"];
            NSInteger question4 = [queryRes intForColumn:@"questionID4"];
            NSInteger question5 = [queryRes intForColumn:@"questionID5"];
            NSInteger question6 = [queryRes intForColumn:@"questionID6"];
            NSInteger question7 = [queryRes intForColumn:@"questionID7"];
            NSInteger question8 = [queryRes intForColumn:@"questionID8"];
            
            questionIDs = @[[NSNumber numberWithInteger:question1], [NSNumber numberWithInteger:question2], [NSNumber numberWithInteger:question3], [NSNumber numberWithInteger:question4], [NSNumber numberWithInteger:question5], [NSNumber numberWithInteger:question6], [NSNumber numberWithInteger:question7], [NSNumber numberWithInteger:question8]];
        }
        
        [queryRes close];
    }];
    
    return questionIDs;
}

- (NSString *)getQuestionWithID:(NSInteger)questionID
{
    // 根据问题ID获取问题内容
    __block NSString *question = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %@", DatabaseQuestionTableQuestionContent, DatabaseQuestionTable, DatabaseQuestionTableQuestionID, @(questionID)];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            question = [queryRes stringForColumn:DatabaseQuestionTableQuestionContent];
        }
        
        [queryRes close];
    }];
    
    return question;
}

- (NSString *)getAnswerWithQuestionID:(NSInteger)questionID date:(NSDate *)date
{
    // 通过问题ID和日期获取对应的回答
    __block NSString *answer = nil;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %@ and date = \"%@\"", DatabaseAnswerTableAnswerContent, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, @(questionID), [PDTimeFunc stringFromDate:date]];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            answer = [queryRes stringForColumn:DatabaseAnswerTableAnswerContent];
        }
        
        [queryRes close];
    }];
    
    return answer;
}

- (NSInteger)getQuestionIDWithQuestionContent:(NSString *)content
{
    // 通过问题内容来获取对应的问题ID
    __block NSInteger questionID = DataBaseQueryResultNotFound;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = \"%@\"", DatabaseQuestionTableQuestionID, DatabaseQuestionTable, DatabaseQuestionTableQuestionContent, content];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            questionID = [queryRes intForColumn:DatabaseQuestionTableQuestionID];
        }
        
        [queryRes close];
    }];
    
    return questionID;
}

- (BOOL)hasQuestionContent:(NSString *)content
{
    // 数据库里是否已经存在这个问题
    __block BOOL exsist = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %@", DatabaseQuestionTableQuestionID, DatabaseQuestionTable, DatabaseQuestionTableQuestionContent, content];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            exsist = YES;
        }
        
        [queryRes close];
    }];
    
    return exsist;
}

- (NSString *)getTemplateQuestionIDNumberWithQuestionID:(NSInteger)questionID templateID:(NSInteger)templateID
{
    // 获取templateID所对应的模板，再根据questionID获取模板中对应的questionIDx
    NSString *questionIDNumber = nil;
    
    NSArray *questionIDs = [self getTemplateQuestionIDsWithTemplateID:templateID];
    for (NSInteger i = 0; i < [questionIDs count]; i++)
    {
        NSInteger ID = [questionIDs[i] integerValue];
        if (ID == questionID)
        {
            questionIDNumber = [NSString stringWithFormat:@"%@%@", DatabaseQuestionTableQuestionID, @(i + 1)];
            break;
        }
    }
    
    return questionIDNumber;
}

- (NSInteger)getTemplateQuestionIDIndexWithQuestionID:(NSInteger)questionID templateID:(NSInteger)templateID
{
    NSString *questionIDNumber = [self getTemplateQuestionIDNumberWithQuestionID:questionID templateID:templateID];
    NSString *indexStr = [questionIDNumber substringFromIndex:[questionIDNumber length] - 1];
    NSInteger index = [indexStr integerValue];
    
    return index - 1;
}

- (NSArray *)getTemplateQuestionIDsWithTemplateID:(NSInteger)templateID
{
    // 获取对应问题模板的所有问题ID
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@ = %@", DatabaseQuestionTemplateTable, DatabaseQuestionTemplateTableTemplateID, @(templateID)];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            NSInteger count = 8;
            for (NSInteger i = 0; i < count; i++)
            {
                NSString *columnName = [NSString stringWithFormat:@"%@%@", DatabaseQuestionTableQuestionID, @(i + 1)];
                NSInteger questionID = [queryRes intForColumn:columnName];
                [array addObject:[NSNumber numberWithInteger:questionID]];
            }
        }
        
        [queryRes close];
    }];
    
    return array;
}

- (NSInteger)getTemplateIDWithQuestionIDs:(NSArray *)questionIDs
{
    // 通过问题获得模板ID
    __block NSInteger templateID = DataBaseQueryResultNotFound;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *str = @"";
        for (NSInteger i = 0; i < [questionIDs count]; i++)
        {
            NSString *judgeStr = [NSString stringWithFormat:@"questionID%@ = %@", @(i + 1), @([questionIDs[i] integerValue])];
            str = [str stringByAppendingString:judgeStr];
            
            if (i != [questionIDs count] - 1)
            {
                str = [str stringByAppendingString:@" and "];
            }
        }
        
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@", DatabaseQuestionTemplateTableTemplateID, DatabaseQuestionTemplateTable, str];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            templateID = [queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
        }
        
        [queryRes close];
    }];
    
    return templateID;
}

- (NSInteger)getTemplateIDWithDate:(NSDate *)date
{
    // 通过日期获取对应的模板ID
    __block NSInteger templateID = DataBaseQueryResultNotFound;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [PDTimeFunc stringFromDate:date]];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            templateID = [queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
        }
        
        [queryRes close];
    }];
    
    return templateID;
}

- (BOOL)diaryTableHasDate:(NSDate *)date
{
    // 判断date是否有编辑过日记
    __block BOOL res = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [PDTimeFunc stringFromDate:date]];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            res = YES;
        }
        
        [queryRes close];
    }];
    
    return res;
}

- (NSArray *)getPhotoDatasWithDate:(NSDate *)date questionID:(NSInteger)questionID
{
    // 通过日期和问题ID获取图片数据
    __block NSMutableArray *datas = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@, %@ from %@ where date = \"%@\" and %@ = %@", DatabasePhotoTablePhotoID, DatabasePhotoTablePhoto, DatabasePhotoTable, [PDTimeFunc stringFromDate:date], DatabaseQuestionTableQuestionID, @(questionID)];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        while ([queryRes next])
        {
            PDPhotoData *photoData = [PDPhotoData new];
            
            NSData *data = [queryRes dataNoCopyForColumn:DatabasePhotoTablePhoto];
            UIImage *image = [UIImage imageWithData:data];
            photoData.image = image;
            
            NSInteger photoID = [queryRes intForColumn:DatabasePhotoTablePhotoID];
            photoData.photoID = photoID;
            
            photoData.questionID = questionID;
            photoData.date = date;
            
            [datas addObject:photoData];
        }
        
        [queryRes close];
    }];
    
    return datas;
}

- (NSInteger)diaryQuantity
{
    // 日记的总数量
    __block NSInteger quantity = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseDiaryTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            quantity = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return quantity;
}

- (NSInteger)editedGridQuantity
{
    // 编辑过的cell的总数量
    __block NSInteger quantity = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@", DatabaseDiaryTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        // 通过遍历存在的日记来计算
        while ([queryRes next])
        {
            NSString *date = [queryRes stringForColumn:DatabaseDate];
            
            NSString *queryQuestionQuantitySql = [NSString stringWithFormat:@"select count (*) from  (select questionID from %@ where date = \"%@\" union select questionID from %@ where date = \"%@\" )", DatabaseAnswerTable, date, DatabasePhotoTable, date];
            FMResultSet * queryQuestionQuantityRes = [db executeQuery:queryQuestionQuantitySql];
            
            if ([queryQuestionQuantityRes next])
            {
                quantity += [queryQuestionQuantityRes intForColumnIndex:0];
            }
            
            [queryQuestionQuantityRes close];
        }
        
        [queryRes close];
    }];
    
    return quantity;
}

- (NSInteger)questionQuantity
{
    // 编辑过的问题的总数量
    __block NSInteger quantity = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"select count(*) from (select %@ from %@ union select %@ from %@)", DatabaseQuestionTableQuestionID, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, DatabasePhotoTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            quantity = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return quantity;
}

- (NSInteger)photoQuantity
{
    // 图片的总数量
    __block NSInteger quantity = 0;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", DatabasePhotoTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            quantity = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return quantity;
}

- (NSArray *)getAllDiaryDate
{
    // 获取所有日记date，降序排序
    __block NSMutableArray *dateArray = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        // 获取所有日记date，降序排序
        NSString *querySql = [NSString stringWithFormat:@"select date from %@ order by date DESC", DatabaseDiaryTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        while ([queryRes next])
        {
            NSString *dateStr = [queryRes stringForColumn:DatabaseDate];
            NSDate *date = [PDTimeFunc dateFromString:dateStr];
            [dateArray addObject:date];
        }
        
        [queryRes close];
    }];
    
    return dateArray;
}

- (NSString *)getWeatherWithDate:(NSDate *)date
{
    // 获取天气
    __block NSString *weather = nil;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where date = \"%@\"", DatabaseWeatherTable, [PDTimeFunc stringFromDate:date]];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            weather = [queryRes stringForColumn:DatabaseWeatherTableWeather];
        }
        
        [queryRes close];
    }];
    
    return weather;
}

- (NSString *)getMoodWithDate:(NSDate *)date
{
    // 获取心情
    __block NSString *mood = nil;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where date = \"%@\"", DatabaseMoodTable, [PDTimeFunc stringFromDate:date]];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            mood = [queryRes stringForColumn:DatabaseMoodTableMood];
        }
        
        [queryRes close];
    }];
    
    return mood;
}

- (BOOL)weatherExsistInDate:(NSDate *)date
{
    // 判断是否存在天气记录
    NSString *weather = [self getWeatherWithDate:date];
    return (weather != nil);
}

- (BOOL)moodExsistInDate:(NSDate *)date
{
    // 判断是否存在心情记录
    NSString *mood = [self getMoodWithDate:date];
    return (mood != nil);
}

- (NSArray *)getAllEditedCellData
{
    NSArray *allDiaryDate = [self getAllDiaryDate];
    __block NSMutableArray *datas = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        for (NSDate *date in allDiaryDate)
        {
            NSString *dateStr = [PDTimeFunc stringFromDate:date];
            NSString *querySql = [NSString stringWithFormat:@"select questionID, date from %@ where date = \"%@\" union select questionID, date from %@ where date = \"%@\"", DatabaseAnswerTable, dateStr, DatabasePhotoTable, dateStr];
            
            FMResultSet * queryRes = [db executeQuery:querySql];
            while ([queryRes next])
            {
                NSInteger questionID = [queryRes intForColumn:DatabaseQuestionTableQuestionID];
                NSString *questionContent = [self getQuestionWithID:questionID];
                NSString *answerContent = [self getAnswerWithQuestionID:questionID date:date];
                
                PDGridInfoCellData *data = [PDGridInfoCellData new];
                data.date = date;
                data.question = questionContent;
                data.answer = answerContent;
                data.images = [NSMutableArray array];
                
                NSArray *photoDatas = [self getPhotoDatasWithDate:date questionID:questionID];
                for (NSInteger i = 0; i < [photoDatas count]; i++)
                {
                    PDPhotoData *photoData = photoDatas[i];
                    [data.images addObject:photoData.image];
                }
                
                [datas addObject:data];
            }
            
            [queryRes close];
        }
    }];
    
    return datas;
}

- (NSArray *)getAllPhotoData
{
    __block NSMutableArray *photoDataArray = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ order by date DESC", DatabasePhotoTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        while ([queryRes next])
        {
            NSString *dateStr = [queryRes stringForColumn:DatabaseDate];
            NSDate *date = [PDTimeFunc dateFromString:dateStr];
            
            NSData *data = [queryRes dataNoCopyForColumn:DatabasePhotoTablePhoto];
            UIImage *image = [UIImage imageWithData:data];
            
            PDPhotoData *photoData = [PDPhotoData new];
            photoData.date = date;
            photoData.image = image;
            
            [photoDataArray addObject:photoData];
        }
        
        [queryRes close];
    }];
    
    return photoDataArray;
}

- (NSArray *)getAllQuestionData
{
    // 编辑过的问题的总数量
    __block NSMutableArray *questionDataArray = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ union select %@ from %@", DatabaseQuestionTableQuestionID, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, DatabasePhotoTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        while ([queryRes next])
        {
            NSInteger questionID = [queryRes intForColumn:DatabaseQuestionTableQuestionID];
            NSString *questionContent = [self getQuestionWithID:questionID];
            
            PDQuestionInfoCellData *questionCellData = [PDQuestionInfoCellData new];
            questionCellData.questionContent = questionContent;
            questionCellData.sectionDataArray = [NSMutableArray array];
//            questionCellData.quatity = [self getQuantityOfQuestionWithID:questionID];
            questionCellData.quatity = [self getQuantityOfQuestionWithID:questionID inDatabase:db];
            
            PDGridInfoSectionData *currentSection = nil;
            
            NSString *query = [NSString stringWithFormat:@"select questionID, date from %@ where questionID = %@ union select questionID, date from %@ where questionID = %@ order by date DESC", DatabaseAnswerTable, @(questionID), DatabasePhotoTable, @(questionID)];
            
            FMResultSet * res = [db executeQuery:query];
            while ([res next])
            {
                NSString *dateStr = [res stringForColumn:DatabaseDate];
                NSDate *date = [PDTimeFunc dateFromString:dateStr];
                NSInteger year = [date yearValue];
                NSInteger month = [date monthValue];
                
                if (!currentSection)
                {
                    currentSection = [PDGridInfoSectionData new];
                    currentSection.year = year;
                    currentSection.month = month;
                    currentSection.cellDatas = [NSMutableArray array];
                }
                
                if ((year != currentSection.year) || (month != currentSection.month))
                {
                    // 不是同年同月，重新建立一个section，原先的section添加到数组中
                    [questionCellData.sectionDataArray addObject:currentSection];
                    
                    currentSection = [PDGridInfoSectionData new];
                    currentSection.year = year;
                    currentSection.month = month;
                    currentSection.cellDatas = [NSMutableArray array];
                }
                
                PDGridInfoCellData *gridCellData = [PDGridInfoCellData new];
                gridCellData.date = date;
                gridCellData.answer = [self getAnswerWithQuestionID:questionID date:date];
                gridCellData.question = [self getQuestionWithID:questionID];
                
                NSArray *photoDatas = [self getPhotoDatasWithDate:date questionID:questionID];
                gridCellData.images = [NSMutableArray array];
                for (NSInteger i = 0; i < [photoDatas count]; i++)
                {
                    PDPhotoData *photoData = photoDatas[i];
                    [gridCellData.images addObject:photoData.image];
                }
                
                [currentSection.cellDatas addObject:gridCellData];
            }
            [res close];
            
            // 遍历之后的最后一次
            [questionCellData.sectionDataArray addObject:currentSection];
            [questionDataArray addObject:questionCellData];
        }
        
        [queryRes close];
    }];
    
    return questionDataArray;
}

- (NSInteger)getQuantityOfQuestionWithID:(NSInteger)questionID inDatabase:(FMDatabase *)db
{
    // 对应问题编辑过的个数
    NSString *querySql = [NSString stringWithFormat:@"select count (*) from (select %@ from %@ where questionID = %@ union all select %@ from %@ where questionID = %@)", DatabaseQuestionTableQuestionID, DatabaseAnswerTable, @(questionID), DatabaseQuestionTableQuestionID, DatabasePhotoTable, @(questionID)];
    FMResultSet * queryRes = [db executeQuery:querySql];
    
    NSInteger quantity = 0;
    if ([queryRes next])
    {
        quantity = [queryRes intForColumnIndex:0];
    }
    [queryRes close];
    
    return quantity;
}

@end
