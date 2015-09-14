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
#define DMLog(...) do { } while (0)
#endif


#endif
