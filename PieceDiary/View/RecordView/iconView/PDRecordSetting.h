//
//  PDRecordSetting.h
//  PieceDiary
//
//  Created by moshuqi on 15/10/4.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDIconSettingView.h"

#define RecordIconSelected      @"Selected"

@interface PDRecordSetting : NSObject

@property (nonatomic, retain) PDIconSettingView *iconView;

- (void)setSelectedWithString:(NSString *)string;
- (NSString *)getSettingString;

@end
