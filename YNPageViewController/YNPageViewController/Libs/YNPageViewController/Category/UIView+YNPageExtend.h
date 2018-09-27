//
//  UIView+YNPageExtend.h
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kYNPAGE_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define kYNPAGE_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// iPhone X/XS: 375*812 (@3x)
// iPhone XS Max: 414*896 (@3x)
// iPhone XR: 414*896 (@2x)
#define kYNPAGE_IS_IPHONE_X  ((kYNPAGE_SCREEN_WIDTH == 375.f && kYNPAGE_SCREEN_HEIGHT == 812.f) || (kYNPAGE_SCREEN_WIDTH == 414.f && kYNPAGE_SCREEN_HEIGHT == 896.f))

#define kYNPAGE_NAVHEIGHT (kYNPAGE_IS_IPHONE_X ? 88 : 64)

#define kYNPAGE_TABBARHEIGHT (kYNPAGE_IS_IPHONE_X ? 83 : 49)

#define kLESS_THAN_iOS11 ([[UIDevice currentDevice].systemVersion floatValue] < 11.0 ? YES : NO)

@interface UIView (YNPageExtend)

@property (nonatomic, assign) CGFloat yn_x;

@property (nonatomic, assign) CGFloat yn_y;

@property (nonatomic, assign) CGFloat yn_width;

@property (nonatomic, assign) CGFloat yn_height;

@property (nonatomic, assign) CGFloat yn_bottom;

@end
