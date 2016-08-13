//
//  PDTimeFunc.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDTimeFunc : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
