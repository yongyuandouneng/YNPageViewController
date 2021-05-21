//
//  SuspendTopPageVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNSuspendTopPageVC.h"
#import "SDCycleScrollView.h"
#import "BaseTableViewVC.h"
#import "YNSuspendTopBaseTableViewVC.h"

@interface YNSuspendTopPageVC () <YNPageViewControllerDataSource, YNPageViewControllerDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, copy) NSArray *imagesURLs;

@end

@implementation YNSuspendTopPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Public Function

+ (instancetype)suspendTopPageVC {
    YNPageConfiguration *configration = [YNPageConfiguration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTop;
    configration.headerViewCouldScale = YES;
    configration.showTabBar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.alignmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    
    YNSuspendTopPageVC *vc = [YNSuspendTopPageVC pageViewControllerWithControllers:[self getArrayVCs]
                                                                            titles:[self getArrayTitles]
                                                                            config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    headerView.layer.contents = (id)[UIImage imageNamed:@"mine_header_bg"].CGImage;
    /// 轮播图
    SDCycleScrollView *autoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200) imageURLStringsGroup:vc.imagesURLs];
    autoScrollView.delegate = vc;
    
//    vc.headerView = autoScrollView;
    
    vc.headerView = headerView;
    // 指定默认选择index 页面
//    vc.pageIndex = 0;
    return vc;
}

+ (NSArray *)getArrayVCs {
    YNSuspendTopBaseTableViewVC *firstVC = [[YNSuspendTopBaseTableViewVC alloc] init];
    firstVC.cellTitle = @"鞋子";
    
    YNSuspendTopBaseTableViewVC *secondVC = [[YNSuspendTopBaseTableViewVC alloc] init];
    secondVC.cellTitle = @"衣服";
    
    YNSuspendTopBaseTableViewVC *thirdVC = [[YNSuspendTopBaseTableViewVC alloc] init];
    return @[firstVC, secondVC, thirdVC];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服", @"帽子"];
}

#pragma mark - Getter and Setter
- (NSArray *)imagesURLs {
    if (!_imagesURLs) {
        _imagesURLs = @[
                        @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                        @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                        @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"];
    }
    return _imagesURLs;
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    YNSuspendTopBaseTableViewVC *vc = pageViewController.controllersM[index];
    return [vc tableView];
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //        NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}

@end

