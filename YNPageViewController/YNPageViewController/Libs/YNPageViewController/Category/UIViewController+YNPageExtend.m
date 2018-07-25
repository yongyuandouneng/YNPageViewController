//
//  UIViewController+YNPageExtend.m
//  YNPageViewController
//
//  Created by ZYN on 2018/5/25.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "UIViewController+YNPageExtend.h"

@implementation UIViewController (YNPageExtend)

- (YNPageViewController *)yn_pageViewController {
    return (YNPageViewController *)self.parentViewController;
}

- (YNPageConfigration *)config {
    YNPageViewController *vc = (YNPageViewController *)self.parentViewController;
    return vc.config;
}

- (YNPageScrollView *)bgScrollView {
    YNPageViewController *vc = (YNPageViewController *)self.parentViewController;
    return vc.bgScrollView;
}

- (YNPageScrollMenuView *)scrollMenuView {
    YNPageViewController *vc = (YNPageViewController *)self.parentViewController;
    return vc.scrollMenuView;
}

- (NSMutableArray *)controllersM {
    YNPageViewController *vc = (YNPageViewController *)self.parentViewController;
    return vc.controllersM;
}

- (NSMutableArray *)titlesM {
    YNPageViewController *vc = (YNPageViewController *)self.parentViewController;
    return vc.titlesM;
}

@end
