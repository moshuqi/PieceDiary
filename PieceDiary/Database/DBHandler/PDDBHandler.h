//
//  PDDBHandler.h
//  PieceDiary
//
//  Created by moshuqi on 16/8/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "PDDatabaseKeyDefine.h"

@interface PDDBHandler : NSObject

@property (nonatomic, strong) FMDatabaseQueue *queue;

+ (instancetype)shareDBHandler;

@end
