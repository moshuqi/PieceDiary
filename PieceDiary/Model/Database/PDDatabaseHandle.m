//
//  PDDatabaseHandle.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDDatabaseHandle.h"
#import "FMDB.h"
#import "PDDefine.h"
#import "PDPhotoDataModel.h"
#import "PDGridInfoCellDataModel.h"
#import "PDQuestionInfoCellDataModel.h"
#import "PDGridInfoSectionDataModel.h"

#define DatabaseName @"PDDatabase.sqlite"

// 数据库table
#define DatabaseQuestionTable               @"QuestionTable"
#define DatabaseAnswerTable                 @"AnswerTable"
#define DatabaseDiaryTable                  @"DiaryTable"
#define DatabaseMoodTable                   @"MoodTable"
#define DatabasePhotoTable                  @"PhotoTable"
#define DatabaseQuestionTemplateTable       @"QuestionTemplateTable"
#define DatabaseWeatherTable                @"WeatherTable"
#define DatabaseDefaultQuestionTemplateTable @"DefaultQuestionTemplateTable"

// 数据库属性
#define DatabaseQuestionTableQuestionID     @"questionID"
#define DatabaseQuestionTableQuestionContent    @"questionContent"
#define DatabaseQuestionTemplateTableTemplateID @"templateID"

#define DatabaseAnswerTableAnswerContent @"answerContent"
#define DatabaseDate    @"date"
#define DatabasePhotoTablePhoto     @"photo"
#define DatabasePhotoTablePhotoID     @"photoID"

#define DatabaseMoodTableMood       @"mood"
#define DatabaseWeatherTableWeather @"weather"

@interface PDDatabaseHandle ()

@property (nonatomic, retain) FMDatabase * database;

@end

@implementation PDDatabaseHandle

- (void)connect
{
    NSString *path = [self getDatabasePath];
    
    // 必须在open前判断，open会在不存在时新建一个sqlite文件
    BOOL needCreateTables = [self needCreateDatabase];
    
    self.database = [[FMDatabase alloc] initWithPath:path];
    BOOL success = [self.database open];
    
    NSString *openMsg = [NSString stringWithFormat:@"数据库打开%@.", (success ? @"成功" : @"失败")];
    PDLog(@"%@", openMsg);
    
    if (needCreateTables)
    {
        [self createDatabaseTables];
        [self initDatabaseData];
    }
    
    NSLog(@"");
}

- (NSString *)getDatabasePath
{
    // 获得数据库文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",DatabaseName]];
    
    return dbPath;
}

- (BOOL)needCreateDatabase
{
    // 判断是否需要重头创建一个数据库。
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:[self getDatabasePath]];
    
    return !exist;
}

#pragma mark - 数据库table的创建

- (void)createDatabaseTables
{
    PDLog(@"数据库初始化.");
    [self createQuestionTable];
    [self createAnswerTable];
    [self createMoodTable];
    [self createPhotoTable];
    [self createQuestionTemplateTable];
    [self createWeatherTable];
    [self createDiaryTable];
    [self createDefaultQuestionTemplateTable];
}

- (void)createQuestionTable
{
    NSString *sql = @"CREATE TABLE \"QuestionTable\" (\"questionID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, \"questionContent\" TEXT NOT NULL UNIQUE)";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseQuestionTable];
}

- (void)createAnswerTable
{
    NSString *sql = @"CREATE TABLE \"AnswerTable\" (\"questionID\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"date\" DATE NOT NULL, \"answerContent\" TEXT NOT NULL, PRIMARY KEY (\"questionID\",\"date\"))";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseAnswerTable];
}

- (void)createMoodTable
{
    NSString *sql = @"CREATE TABLE \"MoodTable\" (\"date\" DATE PRIMARY KEY NOT NULL UNIQUE, \"mood\" TEXT NOT NULL)";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseMoodTable];
}

- (void)createPhotoTable
{
    NSString *sql = @"CREATE TABLE \"PhotoTable\" (\"questionID\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"date\" DATE NOT NULL, \"photo\" BLOB NOT NULL, \"photoID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE)";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabasePhotoTable];
}

- (void)createQuestionTemplateTable
{
    NSString *sql = @"CREATE TABLE \"QuestionTemplateTable\" (\"templateID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, \"questionID1\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID2\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID3\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID4\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID5\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID6\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID7\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID8\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"))";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseQuestionTemplateTable];
}

- (void)createWeatherTable
{
    NSString *sql = @"CREATE TABLE \"WeatherTable\" (\"date\" DATE PRIMARY KEY NOT NULL UNIQUE, \"weather\" TEXT NOT NULL)";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseWeatherTable];
}

- (void)createDiaryTable
{
    NSString *sql = @"CREATE TABLE \"DiaryTable\" (\"date\" DATE PRIMARY KEY NOT NULL UNIQUE, \"templateID\" INTEGER NOT NULL REFERENCES \"QuestionTemplateTable\" (\"templateID\"))";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseDiaryTable];
}

- (void)createDefaultQuestionTemplateTable
{
    NSString *sql = @"CREATE TABLE \"DefaultQuestionTemplateTable\" (\"templateID\" INTEGER PRIMARY KEY NOT NULL UNIQUE REFERENCES \"QuestionTemplateTable\" (\"templateID\"))";
    BOOL res = [self.database executeUpdate:sql];
    [self examWithResult:res tableName:DatabaseDefaultQuestionTemplateTable];
}

#pragma mark - 数据库新创建之后的初始化

- (void)initDatabaseData
{
    // 第一次创建数据库时需要初始化一些数据
    [self initQuestionTableData];
    [self initQuestionTemplateTableData];
    [self initDefaultQuestionTemplateTableData];
}

- (void)initQuestionTableData
{
    // question表初始化最初需要用到的数据。
    NSArray *questionArray = @[@"今天完成了什么？", @"今天锻炼身体了吗？",
                               @"今天关心身边的人了么？", @"今天遇到了什么难题？", @"今天学到了什么？",
                               @"今天有什么特别的新闻？", @"今天吃了什么？", @"明天必须完成的事？"];
    
    for (NSInteger i = 0; i < [questionArray count]; i++)
    {
        NSMutableArray * arguments = [NSMutableArray array];
        [arguments addObject:questionArray[i]];
        
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (questionContent) values (?);", DatabaseQuestionTable];
        BOOL res = [self.database executeUpdate:sql withArgumentsInArray:arguments];
        [self examInsertWithResult:res tableName:DatabaseQuestionTable];
    }
}

- (void)initQuestionTemplateTableData
{
    if (![self matchQuestionTableIDs])
    {
        return;
    }
    
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@", DatabaseQuestionTableQuestionID, DatabaseQuestionTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *questionIDs = [NSMutableArray array];
    while ([queryRes next])
    {
        NSInteger questionID = (NSInteger)[queryRes intForColumn:DatabaseQuestionTableQuestionID];
        [questionIDs addObject:[NSNumber numberWithInteger:questionID]];
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (questionID1, questionID2, questionID3, questionID4, questionID5, questionID6, questionID7, questionID8) values (?, ?, ?, ?, ?, ?, ?, ?);", DatabaseQuestionTemplateTable];
    BOOL insertRes = [self.database executeUpdate:insertSql withArgumentsInArray:questionIDs];
    [self examInsertWithResult:insertRes tableName:DatabaseQuestionTemplateTable];
}

- (BOOL)matchQuestionTableIDs
{
    // 最初模板初始化时需保证QuestionTable中ID的数量为8
    NSString *sql = [NSString stringWithFormat:@"select count(%@) from %@", DatabaseQuestionTableQuestionID, DatabaseQuestionTable];
    FMResultSet * res = [self.database executeQuery:sql];
    
    NSInteger count = 0;
    if ([res next])
    {
        count = [res intForColumnIndex:0];
    }
    
    if (count != 8)
    {
        PDLog(@"模板初始化时，QuestionTable所包含的ID个数不为8");
        return NO;
    }
    
    return YES;
}

- (void)initDefaultQuestionTemplateTableData
{
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@", DatabaseQuestionTemplateTableTemplateID, DatabaseQuestionTemplateTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        NSInteger templateID = (NSInteger)[queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
        NSArray *arguments = [NSArray arrayWithObject:[NSNumber numberWithInteger:templateID]];
        
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (templateID) values (?);", DatabaseDefaultQuestionTemplateTable];
        BOOL res = [self.database executeUpdate:sql withArgumentsInArray:arguments];
        [self examInsertWithResult:res tableName:DatabaseDefaultQuestionTemplateTable];
    }
    else
    {
        PDLog(@"默认模板的初始化失败!");
    }
}


#pragma mark - 数据库操作结果检验

- (void)examWithResult:(BOOL)res tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"创建%@%@.", name, (res ? @"成功" : @"失败")];
    PDLog(@"%@", msg);
}

- (void)examInsertWithResult:(BOOL)res tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"%@插入数据%@.", name, (res ? @"成功" : @"失败")];
    PDLog(@"%@", msg);
}

- (void)examExcuteWithResult:(BOOL)result
{
    if (!result)
    {
        PDLog(@"数据库操作失败");
    }
}

#pragma mark - 数据库查询操作

- (NSInteger)getQuestionTemplateIDWithDate:(NSDate *)date
{
    // 通过日期获取模板
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [PDDatabaseHandle stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    // 查询日期是否有对应的模板，若有，则说明该日期进行过编辑；否则使用对应模板，该日期为第一次进行编辑
    NSInteger templateID;
    if ([queryRes next])
    {
        templateID = (NSInteger)[queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
    }
    else
    {
        templateID = [self getDefaultQuestionTemplateID];
    }
    
    return  templateID;
}

- (NSInteger)getDefaultQuestionTemplateID
{
    // 获取默认模板
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@", DatabaseQuestionTemplateTableTemplateID, DatabaseDefaultQuestionTemplateTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger templateID = 0;
    if ([queryRes next])
    {
        templateID = (NSInteger)[queryRes intForColumnIndex:0];
    }
    else
    {
        PDLog(@"默认模板ID获取有误！");
    }
    
    return templateID;
}

- (NSArray *)getQuestionIDsWithTemplateID:(NSInteger)templateID
{
    // 根据模板ID获取对应所有问题的ID
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", DatabaseQuestionTemplateTable, DatabaseQuestionTemplateTableTemplateID, templateID];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
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
        
        NSArray *questionIDs = @[[NSNumber numberWithInteger:question1], [NSNumber numberWithInteger:question2], [NSNumber numberWithInteger:question3], [NSNumber numberWithInteger:question4], [NSNumber numberWithInteger:question5], [NSNumber numberWithInteger:question6], [NSNumber numberWithInteger:question7], [NSNumber numberWithInteger:question8]];
        return questionIDs;
    }
    else
    {
        PDLog(@"没有获取到对应的模板数据");
        return nil;
    }
}

- (NSString *)getQuestionWithID:(NSInteger)questionID
{
    // 根据问题ID获取问题内容
    
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %ld", DatabaseQuestionTableQuestionContent, DatabaseQuestionTable, DatabaseQuestionTableQuestionID, questionID];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSString *question = nil;
    if ([queryRes next])
    {
        question = [queryRes stringForColumn:DatabaseQuestionTableQuestionContent];
    }
    
    return question;
}

- (NSString *)getAnswerWithQuestionID:(NSInteger)questionID date:(NSDate *)date
{
    // 通过问题ID和日期获取对应的回答
    
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %ld and date = \"%@\"", DatabaseAnswerTableAnswerContent, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, questionID, [PDDatabaseHandle stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSString *answer = nil;
    if ([queryRes next])
    {
        answer = [queryRes stringForColumn:DatabaseAnswerTableAnswerContent];
    }
    
    return answer;
}

- (NSInteger)getQuestionIDWithQuestionContent:(NSString *)content
{
    // 通过问题内容来获取对应的问题ID
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = \"%@\"", DatabaseQuestionTableQuestionID, DatabaseQuestionTable, DatabaseQuestionTableQuestionContent, content];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger questionID = DataBaseQueryResultNotFound;
    if ([queryRes next])
    {
        questionID = [queryRes intForColumn:DatabaseQuestionTableQuestionID];
    }
    
    return questionID;
}

- (BOOL)hasQuestionContent:(NSString *)content
{
    // 数据库里是否已经存在这个问题
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %@", DatabaseQuestionTableQuestionID, DatabaseQuestionTable, DatabaseQuestionTableQuestionContent, content];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        return YES;
    }
    
    return NO;
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
            questionIDNumber = [NSString stringWithFormat:@"%@%ld", DatabaseQuestionTableQuestionID, (i + 1)];
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
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", DatabaseQuestionTemplateTable, DatabaseQuestionTemplateTableTemplateID, templateID];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *array = [NSMutableArray array];
    if ([queryRes next])
    {
        NSInteger count = 8;
        for (NSInteger i = 0; i < count; i++)
        {
            NSString *columnName = [NSString stringWithFormat:@"%@%ld", DatabaseQuestionTableQuestionID, (i + 1)];
            NSInteger questionID = [queryRes intForColumn:columnName];
            [array addObject:[NSNumber numberWithInteger:questionID]];
        }
    }
    
    return array;
}

- (NSInteger)getTemplateIDWithQuestionIDs:(NSArray *)questionIDs
{
    // 通过问题获得模板ID
    NSString *str = @"";
    for (NSInteger i = 0; i < [questionIDs count]; i++)
    {
        NSString *judgeStr = [NSString stringWithFormat:@"questionID%ld = %ld", (i + 1), [questionIDs[i] integerValue]];
        str = [str stringByAppendingString:judgeStr];
        
        if (i != [questionIDs count] - 1)
        {
            str = [str stringByAppendingString:@" and "];
        }
    }
    
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@", DatabaseQuestionTemplateTableTemplateID, DatabaseQuestionTemplateTable, str];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger templateID = DataBaseQueryResultNotFound;
    if ([queryRes next])
    {
        templateID = [queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
    }
    
    return templateID;
}

- (NSInteger)getTemplateIDWithDate:(NSDate *)date
{
    // 通过日期获取对应的模板ID
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [PDDatabaseHandle stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger templateID = DataBaseQueryResultNotFound;
    if ([queryRes next])
    {
        templateID = [queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
    }
    
    return templateID;
}

- (BOOL)diaryTableHasDate:(NSDate *)date
{
    // 判断date是否有编辑过日记
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [PDDatabaseHandle stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        return YES;
    }
    
    return NO;
}

- (NSArray *)getPhotoDatasWithDate:(NSDate *)date questionID:(NSInteger)questionID
{
    // 通过日期和问题ID获取图片数据，包含图片data和图片ID
    
    NSString *querySql = [NSString stringWithFormat:@"select %@, %@ from %@ where date = \"%@\" and %@ = %ld", DatabasePhotoTablePhotoID, DatabasePhotoTablePhoto, DatabasePhotoTable, [PDDatabaseHandle stringFromDate:date], DatabaseQuestionTableQuestionID, questionID];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *photoDatas = [NSMutableArray array];
    while ([queryRes next])
    {
        NSData *data = [queryRes dataNoCopyForColumn:DatabasePhotoTablePhoto];
        NSInteger photoID = [queryRes intForColumn:DatabasePhotoTablePhotoID];
        NSDictionary *dict = @{[NSString stringWithFormat:@"%ld", photoID] : data};
        
        [photoDatas addObject:dict];
    }
    
    return photoDatas;
}

- (NSArray *)getPhotoDataModelsWithDate:(NSDate *)date questionID:(NSInteger)questionID
{
    // 通过日期和问题ID获取图片数据
    
    NSString *querySql = [NSString stringWithFormat:@"select %@, %@ from %@ where date = \"%@\" and %@ = %ld", DatabasePhotoTablePhotoID, DatabasePhotoTablePhoto, DatabasePhotoTable, [PDDatabaseHandle stringFromDate:date], DatabaseQuestionTableQuestionID, questionID];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *models = [NSMutableArray array];
    while ([queryRes next])
    {
        PDPhotoDataModel *dataModel = [PDPhotoDataModel new];
        
        NSData *data = [queryRes dataNoCopyForColumn:DatabasePhotoTablePhoto];
        UIImage *image = [UIImage imageWithData:data];
        dataModel.image = image;
        
        NSInteger photoID = [queryRes intForColumn:DatabasePhotoTablePhotoID];
        dataModel.photoID = photoID;
        
        dataModel.questionID = questionID;
        dataModel.date = date;
        
        [models addObject:dataModel];
    }
    
    return models;
}

- (NSInteger)diaryQuantity
{
    // 日记的总数量
    NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseDiaryTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger quantity = 0;
    if ([queryRes next])
    {
        quantity = [queryRes intForColumnIndex:0];
    }
    
    return quantity;
}

- (NSInteger)editedGridQuantity
{
    // 编辑过的cell的总数量
    NSString *querySql = [NSString stringWithFormat:@"select * from %@", DatabaseDiaryTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    // 通过遍历存在的日记来计算
    NSInteger quantity = 0;
    while ([queryRes next])
    {
        NSString *date = [queryRes stringForColumn:DatabaseDate];
        
        NSString *queryQuestionQuantitySql = [NSString stringWithFormat:@"select count (*) from  (select questionID from %@ where date = \"%@\" union select questionID from %@ where date = \"%@\" )", DatabaseAnswerTable, date, DatabasePhotoTable, date];
        FMResultSet * queryQuestionQuantityRes = [self.database executeQuery:queryQuestionQuantitySql];
        
        if ([queryQuestionQuantityRes next])
        {
            quantity += [queryQuestionQuantityRes intForColumnIndex:0];
        }
    }
    
    return quantity;
}

- (NSInteger)questionQuantity
{
    // 编辑过的问题的总数量
    NSString *querySql = [NSString stringWithFormat:@"select count(*) from (select %@ from %@ union select %@ from %@)", DatabaseQuestionTableQuestionID, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, DatabasePhotoTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger quantity = 0;
    if ([queryRes next])
    {
        quantity = [queryRes intForColumnIndex:0];
    }
    
    return quantity;
}

- (NSInteger)photoQuantity
{
    // 图片的总数量
    NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", DatabasePhotoTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger quantity = 0;
    if ([queryRes next])
    {
        quantity = [queryRes intForColumnIndex:0];
    }
    
    return quantity;
}

- (NSArray *)getAllDiaryDate
{
    // 获取所有日记date，降序排序
    NSString *querySql = [NSString stringWithFormat:@"select date from %@ order by date DESC", DatabaseDiaryTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    while ([queryRes next])
    {
        NSString *dateStr = [queryRes stringForColumn:DatabaseDate];
        NSDate *date = [PDDatabaseHandle dateFromString:dateStr];
        [dateArray addObject:date];
    }
    
    return dateArray;
}

- (NSString *)getWeatherWithDate:(NSDate *)date
{
    // 获取天气
    NSString *weather = nil;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where date = \"%@\"", DatabaseWeatherTable, [PDDatabaseHandle stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        weather = [queryRes stringForColumn:DatabaseWeatherTableWeather];
    }
    
    return weather;
}

- (NSString *)getMoodWithDate:(NSDate *)date
{
    // 获取心情
    NSString *mood = nil;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where date = \"%@\"", DatabaseMoodTable, [PDDatabaseHandle stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        mood = [queryRes stringForColumn:DatabaseMoodTableMood];
    }
    
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
    NSMutableArray *cellDataArray = [NSMutableArray array];
    
    for (NSDate *date in allDiaryDate)
    {
        NSString *dateStr = [PDDatabaseHandle stringFromDate:date];
        NSString *querySql = [NSString stringWithFormat:@"select questionID, date from %@ where date = \"%@\" union select questionID, date from %@ where date = \"%@\"", DatabaseAnswerTable, dateStr, DatabasePhotoTable, dateStr];
        
        FMResultSet * queryRes = [self.database executeQuery:querySql];
        while ([queryRes next])
        {
            NSInteger questionID = [queryRes intForColumn:DatabaseQuestionTableQuestionID];
            NSString *questionContent = [self getQuestionWithID:questionID];
            NSString *answerContent = [self getAnswerWithQuestionID:questionID date:date];
            
            PDGridInfoCellDataModel *cellDataModel = [PDGridInfoCellDataModel new];
            cellDataModel.date = date;
            cellDataModel.question = questionContent;
            cellDataModel.answer = answerContent;
            cellDataModel.images = [NSMutableArray array];
            
            NSArray *photoDatas = [self getPhotoDataModelsWithDate:date questionID:questionID];
            for (NSInteger i = 0; i < [photoDatas count]; i++)
            {
                PDPhotoDataModel *photoDataModel = photoDatas[i];
                [cellDataModel.images addObject:photoDataModel.image];
            }
            
            [cellDataArray addObject:cellDataModel];
        }
    }
    
    return cellDataArray;
}

- (NSArray *)getAllPhotoData
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ order by date DESC", DatabasePhotoTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *photoDataArray = [NSMutableArray array];
    while ([queryRes next])
    {
        NSString *dateStr = [queryRes stringForColumn:DatabaseDate];
        NSDate *date = [PDDatabaseHandle dateFromString:dateStr];
        
        NSData *data = [queryRes dataNoCopyForColumn:DatabasePhotoTablePhoto];
        UIImage *image = [UIImage imageWithData:data];
        
        PDPhotoDataModel *photoData = [PDPhotoDataModel new];
        photoData.date = date;
        photoData.image = image;
        
        [photoDataArray addObject:photoData];
    }
    
    return photoDataArray;
}

- (NSArray *)getAllQuestionData
{
    // 编辑过的问题的总数量
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ union select %@ from %@", DatabaseQuestionTableQuestionID, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, DatabasePhotoTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *questionDataArray = [NSMutableArray array];
    while ([queryRes next])
    {
        NSInteger questionID = [queryRes intForColumn:DatabaseQuestionTableQuestionID];
        NSString *questionContent = [self getQuestionWithID:questionID];
        
        PDQuestionInfoCellDataModel *questionCellDataModel = [PDQuestionInfoCellDataModel new];
        questionCellDataModel.questionContent = questionContent;
        questionCellDataModel.sectionDataArray = [NSMutableArray array];
        questionCellDataModel.quatity = [self getQuantityOfQuestionWithID:questionID];
        
        PDGridInfoSectionDataModel *currentSectionModel = nil;
        
        NSString *query = [NSString stringWithFormat:@"select questionID, date from %@ where questionID = %ld union select questionID, date from %@ where questionID = %ld order by date DESC", DatabaseAnswerTable, questionID, DatabasePhotoTable, questionID];
        
        FMResultSet * res = [self.database executeQuery:query];
        while ([res next])
        {
            NSString *dateStr = [res stringForColumn:DatabaseDate];
            NSDate *date = [PDDatabaseHandle dateFromString:dateStr];
            NSInteger year = [date yearValue];
            NSInteger month = [date monthValue];
            
            if (!currentSectionModel)
            {
                currentSectionModel = [PDGridInfoSectionDataModel new];
                currentSectionModel.year = year;
                currentSectionModel.month = month;
                currentSectionModel.cellDatas = [NSMutableArray array];
            }
            
            if ((year != currentSectionModel.year) || (month != currentSectionModel.month))
            {
                // 不是同年同月，重新建立一个section，原先的section添加到数组中
                [questionCellDataModel.sectionDataArray addObject:currentSectionModel];
                
                currentSectionModel = [PDGridInfoSectionDataModel new];
                currentSectionModel.year = year;
                currentSectionModel.month = month;
                currentSectionModel.cellDatas = [NSMutableArray array];
            }
            
            PDGridInfoCellDataModel *gridCellData = [PDGridInfoCellDataModel new];
            gridCellData.date = date;
            gridCellData.answer = [self getAnswerWithQuestionID:questionID date:date];
            gridCellData.question = [self getQuestionWithID:questionID];
            
            NSArray *photoDataArray = [self getPhotoDataModelsWithDate:date questionID:questionID];
            gridCellData.images = [NSMutableArray array];
            for (NSInteger i = 0; i < [photoDataArray count]; i++)
            {
                PDPhotoDataModel *photoData = photoDataArray[i];
                [gridCellData.images addObject:photoData.image];
            }
            
            [currentSectionModel.cellDatas addObject:gridCellData];
        }
        
        // 遍历之后的最后一次
        [questionCellDataModel.sectionDataArray addObject:currentSectionModel];
        
        
        [questionDataArray addObject:questionCellDataModel];
    }
    
    return questionDataArray;
}

- (NSInteger)getQuantityOfQuestionWithID:(NSInteger)questionID
{
    // 对应问题编辑过的个数
    NSString *querySql = [NSString stringWithFormat:@"select count (*) from (select %@ from %@ where questionID = %ld union all select %@ from %@ where questionID = %ld)", DatabaseQuestionTableQuestionID, DatabaseAnswerTable, questionID, DatabaseQuestionTableQuestionID, DatabasePhotoTable, questionID];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger quantity = 0;
    if ([queryRes next])
    {
        quantity = [queryRes intForColumnIndex:0];
    }
    
    return quantity;
}

#pragma mark - 数据库修改操作

- (void)updateAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date
{
    // 通过问题ID和日期，将答案设为新的值
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = \"%@\" where %@ = %ld and date = \"%@\"", DatabaseAnswerTable, DatabaseAnswerTableAnswerContent, text, DatabaseQuestionTableQuestionID, questionID, [PDDatabaseHandle stringFromDate:date]];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examExcuteWithResult:result];
}

- (void)updateDiaryQuestionTemplateID:(NSInteger)templateID date:(NSDate *)date
{
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = %ld where date = \"%@\"", DatabaseDiaryTable, DatabaseQuestionTemplateTableTemplateID, templateID, [PDDatabaseHandle stringFromDate:date]];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examExcuteWithResult:result];
}

- (void)updateAnswerQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date
{
    // 更新问题对应的ID
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = %ld where date = \"%@\" and %@ = %ld", DatabaseAnswerTable, DatabaseQuestionTableQuestionID, newID, [PDDatabaseHandle stringFromDate:date], DatabaseQuestionTableQuestionID, oldID];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examExcuteWithResult:result];
}

- (void)updatePhotoQuestionIDWithOldID:(NSInteger)oldID newID:(NSInteger)newID date:(NSDate *)date
{
    // 更新图片对应的ID
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = %ld where date = \"%@\" and %@ = %ld", DatabasePhotoTable, DatabaseQuestionTableQuestionID, newID, [PDDatabaseHandle stringFromDate:date], DatabaseQuestionTableQuestionID, oldID];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examExcuteWithResult:result];
}

- (void)updateWeatherWithDate:(NSDate *)date weather:(NSString *)weather
{
    // 修改对应日期的天气
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = \"%@\" where date = \"%@\"", DatabaseWeatherTable, DatabaseWeatherTableWeather, weather, [PDDatabaseHandle stringFromDate:date]];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examExcuteWithResult:result];
}

- (void)updateMoodWithDate:(NSDate *)date mood:(NSString *)mood
{
    // 修改对应日期的心情
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = \"%@\" where date = \"%@\"", DatabaseMoodTable, DatabaseMoodTableMood, mood, [PDDatabaseHandle stringFromDate:date]];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examExcuteWithResult:result];
}

#pragma mark - 数据库插入操作

- (void)insertAnswerContentWith:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date
{
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:[NSNumber numberWithInteger:questionID]];
    [arguments addObject:[PDDatabaseHandle stringFromDate:date]];
    [arguments addObject:text];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@, %@) values (?, ?, ?)", DatabaseAnswerTable, DatabaseQuestionTableQuestionID, DatabaseDate, DatabaseAnswerTableAnswerContent];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

- (void)insertQuestionContentWithText:(NSString *)text
{
    // 插入问题内容
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:text];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values (?)", DatabaseQuestionTable, DatabaseQuestionTableQuestionContent];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

- (void)insertQuestionTemplateWithQuestionIDs:(NSArray *)questionIDs
{
    // 插入新的模板
    NSMutableArray *arguments = [NSMutableArray array];
    for (NSInteger i = 0; i < [questionIDs count]; i++)
    {
        [arguments addObject:questionIDs[i]];
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (questionID1, questionID2, questionID3, questionID4, questionID5, questionID6, questionID7, questionID8) values (?, ?, ?, ?, ?, ?, ?, ?);", DatabaseQuestionTemplateTable];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

- (void)insertDiaryDate:(NSDate *)date questionTemplateID:(NSInteger)templateID
{
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:[PDDatabaseHandle stringFromDate:date]];
    [arguments addObject:[NSNumber numberWithInteger:templateID]];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (?, ?)", DatabaseDiaryTable, DatabaseDate, DatabaseQuestionTemplateTableTemplateID];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

- (void)insertPhotoData:(NSData *)photoData inDate:(NSDate *)date questionID:(NSInteger)questionID
{
    // 插入图片
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:[NSNumber numberWithInteger:questionID]];
    [arguments addObject:[PDDatabaseHandle stringFromDate:date]];
    [arguments addObject:photoData];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@, %@) values (?, ?, ?)", DatabasePhotoTable, DatabaseQuestionTableQuestionID, DatabaseDate, DatabasePhotoTablePhoto];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

- (void)insertWeather:(NSString *)weather inDate:(NSDate *)date
{
    // 插入天气
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:[PDDatabaseHandle stringFromDate:date]];
    [arguments addObject:weather];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (?, ?)", DatabaseWeatherTable, DatabaseDate, DatabaseWeatherTableWeather];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

- (void)insertMood:(NSString *)mood inDate:(NSDate *)date
{
    // 插入心情
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:[PDDatabaseHandle stringFromDate:date]];
    [arguments addObject:mood];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (?, ?)", DatabaseMoodTable, DatabaseDate, DatabaseMoodTableMood];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    [self examExcuteWithResult:result];
}

#pragma mark - 数据库删除操作

- (void)deletePhotoWithPhotoID:(NSInteger)photoID
{
    // 删除图片
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",DatabasePhotoTable, DatabasePhotoTablePhotoID, photoID];
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examExcuteWithResult:result];
}

- (void)deleteAnswerContentWithQuestionID:(NSInteger)questionID date:(NSDate *)date
{
    // 删除回答内容
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld and date = \"%@\"",DatabaseAnswerTable, DatabaseQuestionTableQuestionID, questionID, [PDDatabaseHandle stringFromDate:date]];
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examExcuteWithResult:result];
}

- (void)deleteWeatherWithDate:(NSDate *)date
{
    // 删除天气
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where date = \"%@\"",DatabaseWeatherTable, [PDDatabaseHandle stringFromDate:date]];
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examExcuteWithResult:result];
}

- (void)deleteMoodWithDate:(NSDate *)date
{
    // 删除心情
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where date = \"%@\"",DatabaseMoodTable, [PDDatabaseHandle stringFromDate:date]];
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examExcuteWithResult:result];
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    // 将string转换成date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    // 将date转换成string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

//+ (NSInteger)getYearValueWithDate:(NSDate *)date
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//    
//    NSInteger year = components.year;
//    return year;
//}
//
//+ (NSInteger)getMonthValueWithDate:(NSDate *)date
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//    
//    NSInteger month = components.month;
//    return month;
//}
//
//+ (NSInteger)getWeekdayValueWithDate:(NSDate *)date
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
//    
//    NSInteger weekday = components.weekday;
//    return weekday;
//}
//
//+ (NSInteger)getDayValueWithDate:(NSDate *)date
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//    
//    NSInteger day = components.day;
//    return day;
//}

@end
