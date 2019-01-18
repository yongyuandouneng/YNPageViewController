//
//  SuspendCenterPageVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNSuspendCenterPageVC.h"
#import "SDCycleScrollView.h"
#import "BaseTableViewVC.h"
#import "BaseCollectionViewVC.h"

@interface YNSuspendCenterPageVC () <YNPageViewControllerDataSource, YNPageViewControllerDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, copy) NSArray *imagesURLs;

@property (nonatomic, copy) NSArray *cacheKeyArray;

@end

@implementation YNSuspendCenterPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Public Function
+ (instancetype)suspendCenterPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = true;
    configration.showBottomLine = YES;
    return [self suspendCenterPageVCWithConfig:configration];
}

+ (instancetype)suspendCenterPageVCWithConfig:(YNPageConfigration *)config {
    YNSuspendCenterPageVC *vc = [YNSuspendCenterPageVC pageViewControllerWithControllers:[self getArrayVCs]
                                                                                  titles:[self getArrayTitles]
                                                                                  config:config];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    SDCycleScrollView *autoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200) imageURLStringsGroup:vc.imagesURLs];
    autoScrollView.delegate = vc;
    
    vc.headerView = autoScrollView;
    /// 指定默认选择index 页面
    vc.pageIndex = 2;
    return vc;
}

+ (NSArray *)getArrayVCs {
    BaseTableViewVC *firstVC = [[BaseTableViewVC alloc] init];
    firstVC.cellTitle = @"鞋子";
    
    BaseTableViewVC *secondVC = [[BaseTableViewVC alloc] init];
    secondVC.cellTitle = @"衣服";
    
    BaseCollectionViewVC *thirdVC = [[BaseCollectionViewVC alloc] init];
    return @[firstVC, secondVC, thirdVC];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服", @"帽子"];
}

#pragma mark - Private Function

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

- (NSArray *)cacheKeyArray {
    if (!_cacheKeyArray) {
        _cacheKeyArray = @[@"1", @"2", @"3"];
    }
    return _cacheKeyArray;
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[BaseTableViewVC class]]) {
        return [(BaseTableViewVC *)vc tableView];
    } else {
        return [(BaseCollectionViewVC *)vc collectionView];
    }
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //        NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}

/// 返回列表的高度 默认是控制器的高度大小
//- (CGFloat)pageViewController:(YNPageViewController *)pageViewController heightForScrollViewAtIndex:(NSInteger)index {
//    return 400;
//}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"----click 轮播图 index %ld", index);
}

//- (NSString *)pageViewController:(YNPageViewController *)pageViewController customCacheKeyForIndex:(NSInteger)index {
//    return self.cacheKeyArray[index];
//}

- (void)pageViewController:(YNPageViewController *)pageViewController didScrollMenuItem:(UIButton *)itemButton index:(NSInteger)index {
    NSLog(@"didScrollMenuItem index %ld", index);
}

@end
