//
//  PDGridInfoCellData.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDGridInfoCellData : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSMutableArray *images;

@end
