//
//  PDDatabaseHandle.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDatabaseHandle : NSObject

- (void)connect;

- (NSInteger)getQuestionTemplateIDWithDate:(NSDate *)date;
- (NSInteger)getDefaultQuestionTemplateID;
- (NSArray *)getQuestionIDsWithTemplateID:(NSInteger)templateID;
- (NSString *)getQuestionWithID:(NSInteger)questionID;
- (NSString *)getAnswerWithQuestionID:(NSInteger)questionID date:(NSDate *)date;
- (NSArray *)getPhotosWithQuestionID:(NSInteger)questionID date:(NSDate *)date;

@end
