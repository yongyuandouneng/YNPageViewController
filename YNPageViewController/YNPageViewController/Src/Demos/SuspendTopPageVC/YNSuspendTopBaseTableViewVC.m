//
//  YNSuspendTopBaseTableViewVC.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/25.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNSuspendTopBaseTableViewVC.h"
#import "MJRefresh.h"
#import "UIViewController+YNPageExtend.h"

@interface YNSuspendTopBaseTableViewVC ()

@end

@implementation YNSuspendTopBaseTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 需要设置下拉刷新控件UI的偏移位置
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = self.yn_pageViewController.config.tempTopHeight;
    
}

@end
