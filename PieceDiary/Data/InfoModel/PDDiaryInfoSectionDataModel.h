//
//  PDDiaryInfoSectionDataModel.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDDiaryInfoCellDataModel.h"

@interface PDDiaryInfoSectionDataModel : NSObject

//@property (nonatomic, retain) NSString *sectionName;    // 显示年月的标签
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, retain) NSMutableArray *cellDatas;     // 保存PDDiaryInfoCellDataModel

@end
