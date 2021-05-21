//
//  LoadPageVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/26.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNLoadPageVC.h"
#import "YNPageViewController.h"
#import "YNSuspendCenterPageVC.h"
#import "YNTopPageVC.h"
#import "UIView+YNPageExtend.h"

/// 是否隐藏导航条
#define kHiddenNavigationBar 1

@interface YNLoadPageVC ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation YNLoadPageVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (kHiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (kHiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, 80, 80);
    _indicatorView.center = self.view.center;
    [_indicatorView startAnimating];
    
    /// 模拟器请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupPageVC];
        [self->_indicatorView stopAnimating];
        [self->_indicatorView setHidden:YES];
    });
    [self.view addSubview:_indicatorView];
}

- (void)setupPageVC {
    YNPageConfiguration *configuration = [YNPageConfiguration defaultConfig];
    configuration.pageStyle = YNPageStyleSuspensionCenter;
    configuration.headerViewCouldScale = YES;
    //    configuration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configuration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    /// 控制tabbar 和 nav
    configuration.showTabBar = NO;
    configuration.showNavigation = NO;
    configuration.scrollMenu = NO;
    configuration.alignmentModeCenter = NO;
    configuration.lineWidthEqualFontWidth = NO;
    configuration.showBottomLine = YES;
    configuration.suspendOffsetY = 64;
    /// 裁剪高度
    configuration.cutOutHeight = 44;
    YNSuspendCenterPageVC *pageVC = [YNSuspendCenterPageVC suspendCenterPageVCWithConfig:configuration];
    
    /// 作为自控制器加入到当前控制器
    [pageVC addSelfToParentViewController:self];
    
    /// 如果隐藏了导航条可以 适当改y值
    if (kHiddenNavigationBar) {
//        pageVC.view.yn_y = kYNPAGE_NAVHEIGHT;
    }
    
    /// 底部控件
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 44, kSCREEN_WIDTH, 44)];
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
}

@end
