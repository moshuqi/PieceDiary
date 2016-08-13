//
//  PDDatabaseKeyDefine.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#ifndef PDDatabaseKeyDefine_h
#define PDDatabaseKeyDefine_h

#define DatabaseName @"PDDatabase.sqlite"

// 数据库table
#define DatabaseQuestionTable                   @"QuestionTable"
#define DatabaseAnswerTable                     @"AnswerTable"
#define DatabaseDiaryTable                      @"DiaryTable"
#define DatabaseMoodTable                       @"MoodTable"
#define DatabasePhotoTable                      @"PhotoTable"
#define DatabaseQuestionTemplateTable           @"QuestionTemplateTable"
#define DatabaseWeatherTable                    @"WeatherTable"
#define DatabaseDefaultQuestionTemplateTable    @"DefaultQuestionTemplateTable"

// 数据库属性
#define DatabaseQuestionTableQuestionID             @"questionID"
#define DatabaseQuestionTableQuestionContent        @"questionContent"
#define DatabaseQuestionTemplateTableTemplateID     @"templateID"

#define DatabaseAnswerTableAnswerContent            @"answerContent"
#define DatabaseDate                                @"date"
#define DatabasePhotoTablePhoto                     @"photo"
#define DatabasePhotoTablePhotoID                   @"photoID"

#define DatabaseMoodTableMood                       @"mood"
#define DatabaseWeatherTableWeather                 @"weather"


#endif /* PDDatabaseKeyDefine_h */
