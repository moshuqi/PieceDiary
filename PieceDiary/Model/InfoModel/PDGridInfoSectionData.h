//
//  PDGridInfoSectionDataModel.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDGridInfoCellData.h"

@interface PDGridInfoSectionData : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, retain) NSMutableArray *cellDatas;     // 保存PDGridInfoCellDataModel

@end
