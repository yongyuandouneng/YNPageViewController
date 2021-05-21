//
//  YNNavPageVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNNavPageVC.h"
#import "BaseTableViewVC.h"

@interface YNNavPageVC () <YNPageViewControllerDelegate, YNPageViewControllerDataSource>

@end

@implementation YNNavPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (instancetype)navPageVC {
    YNPageConfiguration *configration = [YNPageConfiguration defaultConfig];
    configration.pageStyle = YNPageStyleNavigation;
    configration.headerViewCouldScale = YES;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabBar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.alignmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    /// 设置菜单栏宽度
    configration.menuWidth = 150;
    
    YNNavPageVC *vc = [YNNavPageVC pageViewControllerWithControllers:[self getArrayVCs]
                                                              titles:[self getArrayTitles]
                                                              config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    return vc;
}

+ (NSArray *)getArrayVCs {
    BaseTableViewVC *firstVC = [[BaseTableViewVC alloc] init];
    firstVC.cellTitle = @"鞋子";
    
    BaseTableViewVC *secondVC = [[BaseTableViewVC alloc] init];
    secondVC.cellTitle = @"衣服";
    
    BaseTableViewVC *thirdVC = [[BaseTableViewVC alloc] init];
    thirdVC.cellTitle = @"帽子";
    return @[firstVC, secondVC, thirdVC];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服", @"帽子"];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    BaseTableViewVC *baseVC = pageViewController.controllersM[index];
    return [baseVC tableView];
}

@end
