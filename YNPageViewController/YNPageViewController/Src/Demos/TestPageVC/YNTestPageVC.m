//
//  YNTestVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/5/8.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNTestPageVC.h"
#import "YNTestBaseVC.h"
#import "SDCycleScrollView.h"

@interface YNTestPageVC () <YNPageViewControllerDataSource, YNPageViewControllerDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, copy) NSArray *imagesURLs;

@end

@implementation YNTestPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

#pragma mark - Public Function
+ (instancetype)testPageVC {
    YNPageConfiguration *configration = [YNPageConfiguration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    //    configration.pageStyle = YNPageStyleNavigation;
    //    configration.pageStyle = YNPageStyleTop;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabBar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.alignmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    //    configration.menuWidth = 250;
    
    YNTestPageVC *vc = [YNTestPageVC pageViewControllerWithControllers:[self getArrayVCs]
                                                                titles:[self getArrayTitles]
                                                                config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    /// 轮播图
    SDCycleScrollView *autoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200) imageURLStringsGroup:vc.imagesURLs];
    autoScrollView.delegate = vc;
    //
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
    headerView.backgroundColor = [UIColor redColor];
    vc.headerView = headerView;
    return vc;
}

+ (NSArray *)getArrayVCs {
    YNTestBaseVC *firstVC = [[YNTestBaseVC alloc] init];
    
    YNTestBaseVC *secondVC = [[YNTestBaseVC alloc] init];
    return @[firstVC, secondVC];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服"];
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
    YNTestBaseVC *baseVC = pageViewController.controllersM[index];
    return [baseVC tableView];
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController contentOffsetY:(CGFloat)contentOffset progress:(CGFloat)progress {
    //    NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"----click 轮播图 index %ld", index);
}

@end
