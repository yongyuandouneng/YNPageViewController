//
//  ScrollMenuStyleVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/25.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNScrollMenuStyleVC.h"
#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
#import "UIView+YNPageExtend.h"

@interface YNScrollMenuStyleVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YNScrollMenuStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    /// style 1
    YNPageConfigration *style_config_1 = [YNPageConfigration defaultConfig];
    YNPageScrollMenuView *style_1 = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44) titles:@[@"JAVA", @"Object-C", @"JS"] configration:style_config_1 delegate:nil currentIndex:0];
    
    
    /// style 2
    YNPageConfigration *style_config_2 = [YNPageConfigration defaultConfig];
    style_config_2.showBottomLine = YES;
    style_config_2.bottomLineBgColor = [UIColor greenColor];
    style_config_2.bottomLineHeight = 1;
    
    YNPageScrollMenuView *style_2 = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, style_1.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"系统偏好设置", @"网易云音乐", @"有道词典", @"微信", @"QQ游戏", @"QQ邮箱", @"数码测色计"] configration:style_config_2 delegate:nil currentIndex:0];
    
    /// style 3
    YNPageConfigration *style_config_3 = [YNPageConfigration defaultConfig];
    style_config_3.showBottomLine = YES;
    style_config_3.bottomLineBgColor = [UIColor greenColor];
    style_config_3.bottomLineHeight = 1;
    style_config_3.scrollMenu = NO;
    style_config_3.aligmentModeCenter = NO;
    style_config_3.lineWidthEqualFontWidth = NO;
    style_config_3.showBottomLine = YES;
    style_config_3.itemFont = [UIFont systemFontOfSize:14];
    style_config_3.selectedItemColor = [UIColor redColor];
    style_config_3.normalItemColor = [UIColor blackColor];
    
    YNPageScrollMenuView *style_3 = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, style_2.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"QQ游戏", @"QQ邮箱", @"数码测色计"] configration:style_config_3 delegate:nil currentIndex:0];
    
    
    /// style 4
    YNPageConfigration *style_config_4 = [YNPageConfigration defaultConfig];
    style_config_4.converColor = [UIColor grayColor];
    style_config_4.showConver = YES;
    style_config_4.itemFont = [UIFont systemFontOfSize:14];
    style_config_4.selectedItemColor = [UIColor redColor];
    style_config_4.normalItemColor = [UIColor blackColor];
    style_config_4.itemMaxScale = 1.1;
    
    
    YNPageScrollMenuView *style_4 = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, style_3.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"QQ游戏", @"QQ邮箱", @"数码测色计"] configration:style_config_4 delegate:nil currentIndex:0];
    
    [_scrollView addSubview:style_1];
    [_scrollView addSubview:style_2];
    [_scrollView addSubview:style_3];
    [_scrollView addSubview:style_4];
    
    [self.view addSubview:_scrollView];
    
}


@end
