//
//  YNPageViewController.h
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNPageConfigration.h"

@class YNPageViewController;

@protocol YNPageViewControllerDelegate <NSObject>
@optional

/**
 滚动列表内容时回调

 @param pageViewController PageVC
 @param contentOffsetY 内容偏移量
 @param progress 进度
 */
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffsetY
                  progress:(CGFloat)progress;

/**
 UIScrollView拖动停止时回调, 可用来自定义 ScrollMenuView

 @param pageViewController PageVC
 @param scrollView UIScrollView
 */
- (void)pageViewController:(YNPageViewController *)pageViewController
        didEndDecelerating:(UIScrollView *)scrollView;

/**
 UIScrollView滚动时回调, 可用来自定义 ScrollMenuView

 @param pageViewController PageVC
 @param scrollView UIScrollView
 @param progress 进度
 @param fromIndex 从哪个页面
 @param toIndex 到哪个页面
 */
- (void)pageViewController:(YNPageViewController *)pageViewController
                 didScroll:(UIScrollView *)scrollView
                  progress:(CGFloat)progress
                 formIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex;

/**
 点击UIScrollMenuView AddAction

 @param pageViewController PageVC
 @param button Add按钮
 */
- (void)pageViewController:(YNPageViewController *)pageViewController
        didAddButtonAction:(UIButton *)button;


@end

@protocol YNPageViewControllerDataSource <NSObject>
@required

- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController
                        pageForIndex:(NSInteger )index;

@end

@interface YNPageViewController : UIViewController
/// 配置信息
@property (nonatomic, strong) YNPageConfigration *config;
/// 控制器数组
@property (nonatomic, strong) NSMutableArray *controllersM;
/// 头部headerView
@property (nonatomic, strong) UIView *headerView;
/// 数据源
@property (nonatomic, weak) id<YNPageViewControllerDataSource> dataSource;
/// 代理
@property (nonatomic, weak) id<YNPageViewControllerDelegate> delegate;
/// 当前页面index
@property (nonatomic, assign) NSInteger pageIndex;
/// 头部伸缩背景View
@property (nonatomic, strong) UIView *scaleBackgroundView;

#pragma mark - initialize

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

/**
 初始化方法
 @param controllers 子控制器
 @param titles 标题
 @param config 配置信息
 */
+ (instancetype)pageViewControllerWithControllers:(NSArray *)controllers
                                           titles:(NSArray *)titles
                                           config:(YNPageConfigration *)config;
/**
 *  当前PageScrollViewVC作为子控制器
 *
 *  @param parentViewControler 父类控制器
 */
- (void)addSelfToParentViewController:(UIViewController *)parentViewControler;

/**
 *  从父类控制器里面移除自己（PageScrollViewVC）
 */
- (void)removeSelfViewController;

/**
 选中页码
 @param pageIndex 页面下标
 */
- (void)setSelectedPageIndex:(NSInteger)pageIndex;


/**
 批量添加控制器

 @param titles 标题数组
 @param controllers 控制器数组
 @param index 插入的下标
 */
- (void)addPageChildControllersWithTitles:(NSArray *)titles
                              controllers:(NSArray *)controllers
                                    index:(NSInteger)index;
/**
 根据标题移除控制器
 */
- (void)removePageControllerWithTtitle:(NSString *)title;

/**
 根据下标移除控制器
 */
- (void)removePageControllerWithIndex:(NSInteger)index;

/**
 *  整个标题替换,相应的控制器也会作出调整。可用作排序功能。
 *
 *  @param titleArray 标题数组
 */
- (void)replaceTitleArray:(NSMutableArray *)titleArray;

@end
