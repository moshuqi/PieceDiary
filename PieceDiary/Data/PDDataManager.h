//
//  PDDataManager.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/17.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDataManager : NSObject

+ (instancetype)defaultManager;

- (NSArray *)getPieceViewDatasWithDate:(NSDate *)date;
- (void)setAnswerContentWithText:(NSString *)text questionID:(NSInteger)questionID date:(NSDate *)date;
- (void)setQuetionContentWithText:(NSString *)text questionID:(NSInteger)questionID;

@end
