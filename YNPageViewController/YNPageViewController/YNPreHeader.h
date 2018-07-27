//
//  YNPreHeader.h
//  YNPageViewController
//
//  Created by ZYN on 2018/5/21.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#ifndef YNPreHeader_h
#define YNPreHeader_h

#import "FTPopOverMenu.h"

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#endif /* YNPreHeader_h */
