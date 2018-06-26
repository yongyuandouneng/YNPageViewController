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

@end
