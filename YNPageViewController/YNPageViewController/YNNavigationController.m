//
//  YNNavigationController.m
//  YNPageViewController
//
//  Created by ZYN on 2018/5/8.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNNavigationController.h"

@interface YNNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation YNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.translucent = NO;
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
}

#pragma mark - --UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    if (self.viewControllers.count == 1) {
        return NO;
    }
    
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"icon_back_small_black"] forState:UIControlStateNormal];
        backBtn.tag = 9898;
        [backBtn sizeToFit];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        viewController.navigationItem.leftBarButtonItem = leftItem;
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backBtnClick {
    [self popViewControllerAnimated:YES];
}
@end
