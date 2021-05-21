//
//  YNTopPageVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNTopPageVC.h"
#import "BaseTableViewVC.h"

@interface YNTopPageVC () <YNPageViewControllerDelegate, YNPageViewControllerDataSource>

@end

@implementation YNTopPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (instancetype)topPageVC {
    YNPageConfiguration *configration = [YNPageConfiguration defaultConfig];
        configration.pageStyle = YNPageStyleTop;
    configration.headerViewCouldScale = YES;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabBar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.alignmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    
    YNTopPageVC *vc = [YNTopPageVC pageViewControllerWithControllers:[self getArrayVCs]
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
