//
//  PDDefine.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/14.
//  Copyright (c) 2015年 msq. All rights reserved.
//

#ifndef PieceDiary_PDDefine_h
#define PieceDiary_PDDefine_h

#ifdef DEBUG
#define PDLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])    //会输出Log所在函数的函数名
#else
#define PDLog(...) do { } while (0)
#endif

// 颜色定义

#define MainBlueColor [UIColor colorWithRed:98 / 255.0 green:198 / 255.0 blue:248 / 255.0 alpha:1.0]

#define BackgroudGrayColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0]

#define TitleTextBlackColor [UIColor colorWithRed:35 / 255.0 green:35 / 255.0 blue:35 / 255.0 alpha:1.0]
#define TitleTextGrayColor [UIColor colorWithRed:191 / 255.0 green:191 / 255.0 blue:191 / 255.0 alpha:1.0]
#define ContentTextColor [UIColor colorWithRed:95 / 255.0 green:95 / 255.0 blue:95 / 255.0 alpha:1.0]


#endif
