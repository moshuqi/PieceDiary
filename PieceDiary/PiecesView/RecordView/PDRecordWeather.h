//
//  PDRecordWeather.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDRecordSetting.h"

typedef NS_ENUM(NSInteger, WeatherRecord){
    WeatherRecordSun = 1,   // 晴
    WeatherRecordCloud,     // 阴
    WeatherRecordWind,      // 风
    WeatherRecordDrizzle,   // 小雨
    WeatherRecordRain,      // 大雨
    WeatherRecordLightning, // 闪电
    WeatherRecordSnow,      // 雪
    WeatherRecordFog        // 雾
};


@interface PDRecordWeather : PDRecordSetting

+ (NSString *)getWeatherStrWithRecordType:(WeatherRecord)weather;
+ (WeatherRecord)getWeatherRecordWithString:(NSString *)string;
+ (NSString *)weatherImageNameWithTag:(NSInteger)tag;

@end
