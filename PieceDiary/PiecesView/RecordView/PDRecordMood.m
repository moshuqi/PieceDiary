//
//  PDRecordMood.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#import "PDRecordMood.h"

#define MoodRecordHappyString           @"高兴"
#define MoodRecordNeutralString         @"平淡"
#define MoodRecordVeryHappyString       @"非常高兴"
#define MoodRecordCoolString            @"酷"
#define MoodRecordUnhappyString         @"不高兴"
#define MoodRecordWonderingString       @"疑惑"
#define MoodRecordSadString             @"悲伤"
#define MoodRecordAngryString           @"生气"


@implementation PDRecordMood

- (NSString *)getNibName
{
    return @"PDIconSettingView";
}

- (NSArray *)getIconDictArray
{
    // 获取选中和正常状态时的图标
    NSMutableArray *dictArray = [NSMutableArray array];
    
    UIImage *normalImage = [UIImage imageNamed:@"mood.jpg"];
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
    NSString *title = [PDRecordMood getMoodStringWithRecordType:(MoodRecord)tag];
    return title;
}

- (NSString *)getNoSettingTip
{
    return @"今天心情如何？";
}

- (NSInteger)getTagWithString:(NSString *)string
{
    MoodRecord mood = [PDRecordMood getMoodRecordWithString:string];
    return mood;
}

+ (NSString *)getMoodStringWithRecordType:(MoodRecord)mood
{
    NSString *str = nil;
    switch (mood)
    {
        case MoodRecordHappy:
            str = MoodRecordHappyString;
            break;
            
        case MoodRecordNeutral:
            str = MoodRecordNeutralString;
            break;
            
        case MoodRecordVeryHappy:
            str = MoodRecordVeryHappyString;
            break;
            
        case MoodRecordCool:
            str = MoodRecordCoolString;
            break;
            
        case MoodRecordUnhappy:
            str = MoodRecordUnhappyString;
            break;
            
        case MoodRecordWondering:
            str = MoodRecordWonderingString;
            break;
            
        case MoodRecordSad:
            str = MoodRecordSadString;
            break;
            
        case MoodRecordAngry:
            str = MoodRecordAngryString;
            break;
            
        default:
            break;
    }
    
    return str;
}


+ (MoodRecord)getMoodRecordWithString:(NSString *)string
{
    MoodRecord mood = MoodRecordHappy;
    if ([string compare:MoodRecordHappyString] == NSOrderedSame)
    {
        mood = MoodRecordHappy;
    }
    else if ([string compare:MoodRecordNeutralString] == NSOrderedSame)
    {
        mood = MoodRecordNeutral;
    }
    else if ([string compare:MoodRecordVeryHappyString] == NSOrderedSame)
    {
        mood = MoodRecordVeryHappy;
    }
    else if ([string compare:MoodRecordCoolString] == NSOrderedSame)
    {
        mood = MoodRecordCool;
    }
    else if ([string compare:MoodRecordUnhappyString] == NSOrderedSame)
    {
        mood = MoodRecordUnhappy;
    }
    else if ([string compare:MoodRecordWonderingString] == NSOrderedSame)
    {
        mood = MoodRecordWondering;
    }
    else if ([string compare:MoodRecordSadString] == NSOrderedSame)
    {
        mood = MoodRecordSad;
    }
    else if ([string compare:MoodRecordAngryString] == NSOrderedSame)
    {
        mood = MoodRecordAngry;
    }
    
    return mood;
}



@end
