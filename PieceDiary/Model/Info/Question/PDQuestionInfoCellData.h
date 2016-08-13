//
//  PDQuestionInfoCellData.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDQuestionInfoCellData : NSObject

@property (nonatomic, retain) NSString *questionContent;
@property (nonatomic, assign) NSInteger quatity;
@property (nonatomic, retain) NSMutableArray *sectionDataArray;    // 保存PDGridInfoSectionData对象

@end
