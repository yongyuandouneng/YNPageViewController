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
    YNPageConfigration *firstConfigStyle = [YNPageConfigration defaultConfig];
    YNPageScrollMenuView *firstStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44) titles:@[@"JAVA", @"Object-C", @"JS"].mutableCopy configration:firstConfigStyle delegate:nil currentIndex:0];
    
    /// style 2
    YNPageConfigration *secondConfigStyle = [YNPageConfigration defaultConfig];
    secondConfigStyle.showBottomLine = YES;
    secondConfigStyle.bottomLineBgColor = [UIColor greenColor];
    secondConfigStyle.bottomLineHeight = 1;
    
    YNPageScrollMenuView *secondStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, firstStyle.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"系统偏好设置", @"网易云音乐", @"有道词典", @"微信", @"QQ游戏", @"QQ邮箱", @"数码测色计"].mutableCopy configration:secondConfigStyle delegate:nil currentIndex:0];
    
    /// style 3
    YNPageConfigration *thirdConfigStyle = [YNPageConfigration defaultConfig];
    thirdConfigStyle.showBottomLine = YES;
    thirdConfigStyle.bottomLineBgColor = [UIColor greenColor];
    thirdConfigStyle.bottomLineHeight = 1;
    thirdConfigStyle.scrollMenu = NO;
    thirdConfigStyle.aligmentModeCenter = NO;
    thirdConfigStyle.lineWidthEqualFontWidth = NO;
    thirdConfigStyle.showBottomLine = YES;
    thirdConfigStyle.itemFont = [UIFont systemFontOfSize:14];
    thirdConfigStyle.selectedItemColor = [UIColor redColor];
    thirdConfigStyle.normalItemColor = [UIColor blackColor];
    
    YNPageScrollMenuView *thirdStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, secondStyle.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"QQ游戏", @"QQ邮箱", @"数码测色计"].mutableCopy configration:thirdConfigStyle delegate:nil currentIndex:0];
    
    /// style 4
    YNPageConfigration *fourthConfigStyle = [YNPageConfigration defaultConfig];
    fourthConfigStyle.converColor = [UIColor grayColor];
    fourthConfigStyle.showConver = YES;
    fourthConfigStyle.itemFont = [UIFont systemFontOfSize:20];
    fourthConfigStyle.selectedItemFont = [UIFont systemFontOfSize:20];
    fourthConfigStyle.selectedItemColor = [UIColor redColor];
    fourthConfigStyle.normalItemColor = [UIColor blackColor];
    fourthConfigStyle.itemMaxScale = 1.3;
    
    YNPageScrollMenuView *fourthStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, thirdStyle.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"QQ游戏", @"QQ邮箱", @"数码测色计"].mutableCopy configration:fourthConfigStyle delegate:nil currentIndex:2];
    
    /// style 5
    YNPageConfigration *fifthConfigStyle = [YNPageConfigration defaultConfig];
    fifthConfigStyle.selectedItemColor = [UIColor redColor];
    fifthConfigStyle.selectedItemFont = [UIFont systemFontOfSize:15];
    
    YNPageScrollMenuView *fifthStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, fourthStyle.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"JAVA", @"Object-C", @"JS"].mutableCopy configration:fifthConfigStyle delegate:nil currentIndex:1];
    
    /// style 6
    YNPageConfigration *sixthConfigStyle = [YNPageConfigration defaultConfig];
    sixthConfigStyle.scrollMenu = YES;
    sixthConfigStyle.aligmentModeCenter = NO;
    sixthConfigStyle.bottomLineHeight = 1;
    sixthConfigStyle.bottomLineBgColor = [UIColor greenColor];
    sixthConfigStyle.showBottomLine = YES;
    YNPageScrollMenuView *sixthStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, fifthStyle.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"JAVA", @"Object-C", @"JS"].mutableCopy configration:sixthConfigStyle delegate:nil currentIndex:1];
    
    /// style 7
    YNPageConfigration *seventhConfigStyle = [YNPageConfigration defaultConfig];
    seventhConfigStyle.scrollMenu = NO;
    seventhConfigStyle.aligmentModeCenter = NO;
    NSMutableArray *buttonArrayM = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"small_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_back_small_black"] forState:UIControlStateSelected];
        
        /// seTitle -> sizeToFit -> 自行调整位置
        /// button.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
        [buttonArrayM addObject:button];
    }
    seventhConfigStyle.buttonArray = buttonArrayM;
    
    YNPageScrollMenuView *seventhStyle = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, sixthStyle.yn_bottom + 20, kSCREEN_WIDTH, 44) titles:@[@"带iCON", @"小图标", @"位置"].mutableCopy configration:seventhConfigStyle delegate:nil currentIndex:1];
    
    [_scrollView addSubview:firstStyle];
    [_scrollView addSubview:secondStyle];
    [_scrollView addSubview:thirdStyle];
    [_scrollView addSubview:fourthStyle];
    [_scrollView addSubview:fifthStyle];
    [_scrollView addSubview:sixthStyle];
    [_scrollView addSubview:seventhStyle];
    
    [self.view addSubview:_scrollView];
}

@end
