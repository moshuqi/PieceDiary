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


- (void)cancelRecord
{
    
}


- (NSString *)getImageNameWithTag:(NSInteger)tag
{
    return [PDRecordWeather weatherImageNameWithTag:tag];
}

+ (NSString *)weatherImageNameWithTag:(NSInteger)tag
{
    NSString *imageName = nil;
    WeatherRecord weather = (WeatherRecord)tag;
    
    switch (weather)
    {
        case WeatherRecordSun:
            imageName = @"sun";
            break;
            
        case WeatherRecordCloud:
            imageName = @"cloud";
            break;
            
        case WeatherRecordWind:
            imageName = @"wind";
            break;
            
        case WeatherRecordDrizzle:
            imageName = @"drizzle";
            break;
            
        case WeatherRecordRain:
            imageName = @"rain";
            break;
            
        case WeatherRecordLightning:
            imageName = @"lightning";
            break;
            
        case WeatherRecordSnow:
            imageName = @"snow";
            break;
            
        case WeatherRecordFog:
            imageName = @"fog";
            break;
            
        default:
            break;
    }
    
    return imageName;
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

+ (UIImage *)getWeatherImageWithWeatherString:(NSString *)weatherString
{
    WeatherRecord weather = [PDRecordWeather getWeatherRecordWithString:weatherString];
    NSString *imageName = [PDRecordWeather weatherImageNameWithTag:weather];
    NSString *extStr = [NSString stringWithFormat:@"%@.png", RecordIconSelected];
    imageName = [imageName stringByAppendingString:extStr];
    
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

+ (UIImage *)getMoodDefaultImage
{
    NSString *imageName = [PDRecordWeather weatherImageNameWithTag:WeatherRecordSun];
    imageName = [imageName stringByAppendingString:@".png"];
    UIImage *image = [UIImage imageNamed:imageName];
    
    return image;
}


@end
