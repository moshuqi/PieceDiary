//
//  PDDateCellDataModel.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/21.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDDateCellDataModel : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) UIImage *weatherIcon;
@property (nonatomic, retain) UIImage *moodIcon;

@end
