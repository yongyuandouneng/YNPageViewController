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

@interface YNLoadPageVC () <YNPageViewControllerDelegate, YNPageViewControllerDataSource>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation YNLoadPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, 80, 80);
    _indicatorView.center = self.view.center;
    [_indicatorView startAnimating];
    
    /// 模拟器请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self setupPageVC];
        
        [_indicatorView stopAnimating];
        [_indicatorView setHidden:YES];
    });
    
    [self.view addSubview:_indicatorView];
    
}

- (void)setupPageVC {
    
//    YNTopPageVC *pageVC = [YNTopPageVC topPageVC];
    
    YNSuspendCenterPageVC *pageVC = [YNSuspendCenterPageVC suspendCenterPageVC];
    
    /// 作为自控制器加入到当前控制器
    [pageVC addSelfToParentViewController:self];
    
}

@end
