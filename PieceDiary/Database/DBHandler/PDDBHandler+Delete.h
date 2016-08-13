//
//  PDDBHandler+Delete.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "PDDBHandler.h"

@interface PDDBHandler (Delete)

- (void)deletePhotoWithPhotoID:(NSInteger)photoID;
- (void)deleteAnswerContentWithQuestionID:(NSInteger)questionID date:(NSDate *)date;
- (void)deleteWeatherWithDate:(NSDate *)date;
- (void)deleteMoodWithDate:(NSDate *)date;

@end
