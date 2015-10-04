//
//  PDRecordWeather.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordWeather.h"


#define WeatherRecordSunString          @"晴"
#define WeatherRecordCloudString        @"阴"
#define WeatherRecordWindString         @"风"
#define WeatherRecordDrizzleString      @"小雨"
#define WeatherRecordRainString         @"大雨"
#define WeatherRecordLightningString    @"闪电"
#define WeatherRecordSnowString         @"雪"
#define WeatherRecordFogString          @"雾"

@implementation PDRecordWeather

- (NSString *)getNibName
{
    return @"PDIconSettingView";
}

- (NSArray *)getIconDictArray
{
    // 获取选中和正常状态时的图标
    NSMutableArray *dictArray = [NSMutableArray array];
    
    UIImage *normalImage = [UIImage imageNamed:@"weather.jpg"];
    UIImage *selectedImage = [UIImage imageNamed:@"1.jpg"];
    
    NSDictionary *dic1 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic1];
    
    NSDictionary *dic2 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic2];
    
    NSDictionary *dic3 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic3];
    
    NSDictionary *dic4 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic4];
    
    NSDictionary *dic5 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic5];
    
    NSDictionary *dic6 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic6];
    
    NSDictionary *dic7 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic7];
    
    NSDictionary *dic8 = @{PDIconSettingNormalImageKey : normalImage,
                           PDIconSettingSelectedImageKey : selectedImage};
    [dictArray addObject:dic8];
    
    return dictArray;
}

- (void)cancelRecord
{
    
}

- (NSString *)getTitleTextWithButtonTag:(NSInteger)tag
{
    NSString *title = [PDRecordWeather getWeatherStrWithRecordType:(WeatherRecord)tag];
    return title;
}

- (NSString *)getNoSettingTip
{
    return @"今天天气如何？";
}

- (NSInteger)getTagWithString:(NSString *)string
{
    WeatherRecord weather = [PDRecordWeather getWeatherRecordWithString:string];
    return weather;
}

+ (NSString *)getWeatherStrWithRecordType:(WeatherRecord)weather
{
    NSString *str = nil;
    switch (weather)
    {
        case WeatherRecordSun:
            str = WeatherRecordSunString;
            break;
            
        case WeatherRecordCloud:
            str = WeatherRecordCloudString;
            break;
            
        case WeatherRecordWind:
            str = WeatherRecordWindString;
            break;
            
        case WeatherRecordDrizzle:
            str = WeatherRecordDrizzleString;
            break;
            
        case WeatherRecordRain:
            str = WeatherRecordRainString;
            break;
            
        case WeatherRecordLightning:
            str = WeatherRecordLightningString;
            break;
            
        case WeatherRecordSnow:
            str = WeatherRecordSnowString;
            break;
            
        case WeatherRecordFog:
            str = WeatherRecordFogString;
            break;
            
        default:
            break;
    }
    
    return str;
}

+ (WeatherRecord)getWeatherRecordWithString:(NSString *)string
{
    WeatherRecord weather = WeatherRecordSun;
    if ([string compare:WeatherRecordSunString] == NSOrderedSame)
    {
        weather = WeatherRecordSun;
    }
    else if ([string compare:WeatherRecordCloudString] == NSOrderedSame)
    {
        weather = WeatherRecordCloud;
    }
    else if ([string compare:WeatherRecordWindString] == NSOrderedSame)
    {
        weather = WeatherRecordWind;
    }
    else if ([string compare:WeatherRecordDrizzleString] == NSOrderedSame)
    {
        weather = WeatherRecordDrizzle;
    }
    else if ([string compare:WeatherRecordRainString] == NSOrderedSame)
    {
        weather = WeatherRecordRain;
    }
    else if ([string compare:WeatherRecordLightningString] == NSOrderedSame)
    {
        weather = WeatherRecordLightning;
    }
    else if ([string compare:WeatherRecordSnowString] == NSOrderedSame)
    {
        weather = WeatherRecordSnow;
    }
    else if ([string compare:WeatherRecordFogString] == NSOrderedSame)
    {
        weather = WeatherRecordFog;
    }

    
    return weather;
}


@end
