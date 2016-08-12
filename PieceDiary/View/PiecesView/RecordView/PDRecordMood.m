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


- (void)cancelRecord
{
    
}

+ (UIImage *)getDefaultMoodImage
{
    UIImage *image;
    
    
    return image;
}

- (NSString *)getImageNameWithTag:(NSInteger)tag
{
    return [PDRecordMood moodImageNameWithTag:tag];
}

+ (NSString *)moodImageNameWithTag:(NSInteger)tag
{
    NSString *imageName = nil;
    MoodRecord mood = (MoodRecord)tag;
    
    switch (mood)
    {
        case MoodRecordHappy:
            imageName = @"happy";
            break;
            
        case MoodRecordNeutral:
            imageName = @"neutral";
            break;
            
        case MoodRecordVeryHappy:
            imageName = @"veryHappy";
            break;
            
        case MoodRecordCool:
            imageName = @"cool";
            break;
            
        case MoodRecordUnhappy:
            imageName = @"unhappy";
            break;
            
        case MoodRecordWondering:
            imageName = @"wondering";
            break;
            
        case MoodRecordSad:
            imageName = @"sad";
            break;
            
        case MoodRecordAngry:
            imageName = @"angry";
            break;
            
        default:
            break;
    }
    
    return imageName;
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

+ (UIImage *)getMoodImageWithMoodString:(NSString *)moodString
{
    MoodRecord mood = [PDRecordMood getMoodRecordWithString:moodString];
    NSString *imageName = [PDRecordMood moodImageNameWithTag:mood];
    NSString *extStr = [NSString stringWithFormat:@"%@.png", RecordIconSelected];
    imageName = [imageName stringByAppendingString:extStr];
    
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

+ (UIImage *)getMoodDefaultImage
{
    NSString *imageName = [PDRecordMood moodImageNameWithTag:MoodRecordHappy];
    imageName = [imageName stringByAppendingString:@".png"];
    UIImage *image = [UIImage imageNamed:imageName];
    
    return image;
}



@end
