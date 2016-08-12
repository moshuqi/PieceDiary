//
//  PDPhotoDataModel.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDPhotoDataModel : NSObject

@property (nonatomic, assign) NSInteger questionID;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) NSInteger photoID;

@end
