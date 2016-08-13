//
//  PDDBHandler.m
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler.h"
#import "PDDBHandler+Query.h"

@implementation PDDBHandler

static PDDBHandler *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareDBHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PDDBHandler alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self connect];
    }
    
    return self;
}

- (void)connect
{
    NSString *path = [self getDatabasePath];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self createDatabaseTables];
    [self initTableData];
}

- (NSString *)getDatabasePath
{
    // 获得数据库文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@", DatabaseName]];
    
    return dbPath;
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
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"QuestionTable\" (\"questionID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, \"questionContent\" TEXT NOT NULL UNIQUE)";
    [self createTableWithSql:sql tableName:DatabaseQuestionTable];
}

- (void)createAnswerTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"AnswerTable\" (\"questionID\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"date\" DATE NOT NULL, \"answerContent\" TEXT NOT NULL, PRIMARY KEY (\"questionID\",\"date\"))";
    [self createTableWithSql:sql tableName:DatabaseAnswerTable];
}

- (void)createMoodTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"MoodTable\" (\"date\" DATE PRIMARY KEY NOT NULL UNIQUE, \"mood\" TEXT NOT NULL)";
    [self createTableWithSql:sql tableName:DatabaseMoodTable];
}

- (void)createPhotoTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"PhotoTable\" (\"questionID\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"date\" DATE NOT NULL, \"photo\" BLOB NOT NULL, \"photoID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE)";
    [self createTableWithSql:sql tableName:DatabasePhotoTable];
}

- (void)createQuestionTemplateTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"QuestionTemplateTable\" (\"templateID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, \"questionID1\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID2\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID3\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID4\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID5\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID6\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID7\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"), \"questionID8\" INTEGER NOT NULL REFERENCES \"QuestionTable\" (\"questionID\"))";
    [self createTableWithSql:sql tableName:DatabaseQuestionTemplateTable];
}

- (void)createWeatherTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"WeatherTable\" (\"date\" DATE PRIMARY KEY NOT NULL UNIQUE, \"weather\" TEXT NOT NULL)";
    [self createTableWithSql:sql tableName:DatabaseWeatherTable];
}

- (void)createDiaryTable
{
    NSString *sql = @"CREATE TABLE \"DiaryTable\" (\"date\" DATE PRIMARY KEY NOT NULL UNIQUE, \"templateID\" INTEGER NOT NULL REFERENCES \"QuestionTemplateTable\" (\"templateID\"))";
    [self createTableWithSql:sql tableName:DatabaseDiaryTable];
}

- (void)createDefaultQuestionTemplateTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS \"DefaultQuestionTemplateTable\" (\"templateID\" INTEGER PRIMARY KEY NOT NULL UNIQUE REFERENCES \"QuestionTemplateTable\" (\"templateID\"))";
    [self createTableWithSql:sql tableName:DatabaseDefaultQuestionTemplateTable];
}

- (void)createTableWithSql:(NSString *)sql tableName:(NSString *)name
{
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:sql];
        [self createWithResult:res tableName:name];
    }];
}

- (void)createWithResult:(BOOL)res tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"创建%@ %@.", name, (res ? @"成功" : @"失败")];
    PDLog(@"%@", msg);
}

#pragma mark - 数据库新创建之后的初始化

- (void)initTableData
{
    // 第一次创建数据库时，需要初始化一些数据
    if ([self queryQuestionCount] == 0)
    {
        [self initQuestionTableData];
    }
    
    if ([self queryQuestionTemplateCount] == 0)
    {
        [self initQuestionTemplateTableData];
    }
    
    if ([self queryDefaultQuestionTemplateCount] == 0)
    {
        [self initDefaultQuestionTemplateTableData];
    }
}

- (void)initQuestionTableData
{
    // question表初始化最初需要用到的数据。
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSArray *questionArray = @[@"今天完成了什么？", @"今天锻炼身体了吗？",
                                   @"今天关心身边的人了么？", @"今天遇到了什么难题？", @"今天学到了什么？",
                                   @"今天有什么特别的新闻？", @"今天吃了什么？", @"明天必须完成的事？"];
        
        for (NSInteger i = 0; i < [questionArray count]; i++)
        {
            NSMutableArray * arguments = [NSMutableArray array];
            [arguments addObject:questionArray[i]];
            
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (questionContent) values (?);", DatabaseQuestionTable];
            BOOL res = [db executeUpdate:sql withArgumentsInArray:arguments];
            [self examInitDataResult:res tableName:DatabaseQuestionTable];
        }
    }];
}

- (void)initQuestionTemplateTableData
{
    // 问题模板需要包含8个问题
    if ([self queryQuestionCount] != 8)
    {
        PDLog(@"问题的初始化个数错误!");
        return;
    }
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@", DatabaseQuestionTableQuestionID, DatabaseQuestionTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        NSMutableArray *questionIDs = [NSMutableArray array];
        while ([queryRes next])
        {
            NSInteger questionID = (NSInteger)[queryRes intForColumn:DatabaseQuestionTableQuestionID];
            [questionIDs addObject:[NSNumber numberWithInteger:questionID]];
        }
        [queryRes close];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (questionID1, questionID2, questionID3, questionID4, questionID5, questionID6, questionID7, questionID8) values (?, ?, ?, ?, ?, ?, ?, ?);", DatabaseQuestionTemplateTable];
        BOOL res = [db executeUpdate:insertSql withArgumentsInArray:questionIDs];
        [self examInitDataResult:res tableName:DatabaseQuestionTemplateTable];
    }];
}

- (void)initDefaultQuestionTemplateTableData
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@", DatabaseQuestionTemplateTableTemplateID, DatabaseQuestionTemplateTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            NSInteger templateID = (NSInteger)[queryRes intForColumn:DatabaseQuestionTemplateTableTemplateID];
            NSArray *arguments = [NSArray arrayWithObject:[NSNumber numberWithInteger:templateID]];
            
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (templateID) values (?);", DatabaseDefaultQuestionTemplateTable];
            BOOL res = [db executeUpdate:sql withArgumentsInArray:arguments];
            [self examInitDataResult:res tableName:DatabaseDefaultQuestionTemplateTable];
        }
        else
        {
            PDLog(@"默认模板的初始化失败!");
        }
        
        [queryRes close];
    }];
}

- (void)examInitDataResult:(BOOL)result tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"初始化%@数据 %@.", name, (result ? @"成功" : @"失败")];
    PDLog(@"%@", msg);
}

@end
