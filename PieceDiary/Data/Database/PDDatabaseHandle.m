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
    NSString *sql = @"CREATE TABLE \"QuestionTemplateTable\" (\"templateID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, \"questionID1\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID2\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID3\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID4\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID5\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID6\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID7\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID8\" TEXT NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"))";
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

#pragma mark - 数据库查询操作

- (NSInteger)getQuestionTemplateIDWithDate:(NSDate *)date
{
    // 通过日期获取模板
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where date = \"%@\"", DatabaseQuestionTemplateTableTemplateID, DatabaseDiaryTable, [self stringFromDate:date]];
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
    
    NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@ = %ld and date = %@", DatabaseAnswerTableAnswerContent, DatabaseAnswerTable, DatabaseQuestionTableQuestionID, questionID, [self stringFromDate:date]];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSString *answer = nil;
    if ([queryRes next])
    {
        answer = [queryRes stringForColumn:DatabaseAnswerTableAnswerContent];
    }
    
    return answer;
}

- (NSArray *)getPhotosWithQuestionID:(NSInteger)questionID date:(NSDate *)date
{
    // 通过问题ID和日期获取对应的图片
    
    return nil;
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    // 将string转换成date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    // 将date转换成string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

@end
