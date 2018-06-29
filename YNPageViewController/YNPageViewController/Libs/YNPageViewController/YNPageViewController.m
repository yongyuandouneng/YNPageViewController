//
//  YNPageViewController.m
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageViewController.h"
#import "UIView+YNPageExtend.h"
#import "YNPageScrollView.h"
#import "YNPageScrollMenuView.h"
#import "UIScrollView+YNPageExtend.h"
#import "YNPageHeaderScrollView.h"

@interface YNPageViewController () <UIScrollViewDelegate, YNPageScrollMenuViewDelegate>
/// 标题数组
@property (nonatomic, strong) NSMutableArray *titlesM;
/// 一个HeaderView的背景View
@property (nonatomic, strong) YNPageHeaderScrollView *headerBgView;
/// 页面ScrollView
@property (nonatomic, strong) YNPageScrollView *pageScrollView;
/// 菜单栏
@property (nonatomic, strong) YNPageScrollMenuView *scrollMenuView;
/// 展示控制器的字典
@property (nonatomic, strong) NSMutableDictionary *displayDictM;
/// 字典控制器的字典
@property (nonatomic, strong) NSMutableDictionary *cacheDictM;
/// 当前显示的页面
@property (nonatomic, strong) UIScrollView *currentScrollView;
/// 当前控制器
@property (nonatomic, strong) UIViewController *currentViewController;
/// 上次偏移的位置
@property (nonatomic, assign) CGFloat lastPositionX;
/// TableView距离顶部的偏移量
@property (nonatomic, assign) CGFloat insetTop;
/// 判断headerView是否在列表内
@property (nonatomic, assign) BOOL headerViewInTableView;
/// 菜单栏的初始OriginY
@property (nonatomic, assign) CGFloat scrollMenuViewOriginY;
/// headerView的原始高度 用来处理头部伸缩效果
@property (nonatomic, assign) CGFloat headerViewOriginHeight;
/// 是否是悬浮状态
@property (nonatomic, assign) BOOL supendStatus;

@end

@implementation YNPageViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupSubViews];
    
    if (self.pageIndex == 0) {
        [self initViewControllerWithIndex:self.pageIndex];
    } else {
        [self setSelectedPageIndex:self.pageIndex];
    }
    
    self.pageScrollView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Initialize Method

- (instancetype)init {
    self = [super init];
    if (self) {
        _displayDictM = @{}.mutableCopy;
        _cacheDictM = @{}.mutableCopy;
    }
    return self;
}

/**
 初始化方法
 @param controllers 子控制器
 @param titles 标题
 @param config 配置信息
 */
+ (instancetype)pageViewControllerWithControllers:(NSArray *)controllers
                                           titles:(NSArray *)titles
                                           config:(YNPageConfigration *)config {
    YNPageViewController *vc = [[self alloc] init];
    vc.controllersM = controllers.mutableCopy;
    vc.titlesM = titles.mutableCopy;
    vc.config = config ?: [YNPageConfigration defaultConfig];
    
    return vc;
}

/**
 *  当前PageScrollViewVC作为子控制器
 *
 *  @param parentViewControler 父类控制器
 */
- (void)addSelfToParentViewController:(UIViewController *)parentViewControler {
    [self addChildViewControllerWithChildVC:self parentVC:parentViewControler];
}

/**
 *  从父类控制器里面移除自己（PageScrollViewVC）
 */
- (void)removeSelfViewController {
    [self removeViewControllerWithChildVC:self];
}

#pragma mark - 初始化PageScrollMenu
- (void)initPagescrollMenuViewWithFrame:(CGRect)frame {
    
    YNPageScrollMenuView *scrollMenuView = [YNPageScrollMenuView pagescrollMenuViewWithFrame:frame
                                                                                      titles:self.titlesM
                                                                                configration:self.config
                                                                                    delegate:self currentIndex:self.pageIndex];
    self.scrollMenuView = scrollMenuView;
    
    if ([self isNavigationStyle]) {
        self.navigationItem.titleView = self.scrollMenuView;
        return;
    }
    [self.view addSubview:self.scrollMenuView];
    
    _insetTop = self.headerBgView.yn_height + self.scrollMenuView.yn_height;
    
}

#pragma mark - 初始化子控制器
- (void)initViewControllerWithIndex:(NSInteger)index {
    
    self.currentViewController = self.controllersM[index];

    self.pageIndex = index;
    NSString *title = [self titleWithIndex:index];
    if ([self.displayDictM objectForKey:title]) return;
    
    UIViewController *cacheViewController = [self.cacheDictM objectForKey:title];
    [self addViewControllerToParent:cacheViewController ?: self.controllersM[index] index:index];

}
/// 添加到父类控制器中
- (void)addViewControllerToParent:(UIViewController *)viewController index:(NSInteger)index {
    
    [self addChildViewController:self.controllersM[index]];
    
    viewController.view.frame = CGRectMake(kYNPAGE_SCREEN_WIDTH * index, 0, self.pageScrollView.yn_width, self.pageScrollView.yn_height);
    
    [self.pageScrollView addSubview:viewController.view];
    
    NSString *title = [self titleWithIndex:index];
    
    [self.displayDictM setObject:viewController forKey:title];
    
    UIScrollView *scrollView = self.currentScrollView;
    scrollView.frame = viewController.view.bounds;
    
    [viewController didMoveToParentViewController:self];
    
    if ([self isSuspensionBottomStyle] || [self isSuspensionTopStyle]) {
        if (self.cacheDictM.count == 0) {
            /// 初次添加headerView、scrollMenuView
            self.headerBgView.yn_y = - _insetTop;
            self.scrollMenuView.yn_y = self.headerBgView.yn_bottom;
            [scrollView addSubview:self.headerBgView];
            [scrollView addSubview:self.scrollMenuView];
            /// 设置首次偏移量置顶
            [scrollView setContentOffset:CGPointMake(0, -_insetTop) animated:NO];
            
        } else {
            CGFloat scrollMenuViewY = [self.scrollMenuView.superview convertRect:self.scrollMenuView.frame toView:self.view].origin.y;
            
            if (self.supendStatus) {
                /// 首次已经悬浮 设置初始化 偏移量
                if (![self.cacheDictM objectForKey:title]) {
                    [scrollView setContentOffset:CGPointMake(0, -self.config.menuHeight) animated:NO];
                } else {
                    /// 再次悬浮 已经加载过 设置偏移量
                    if (scrollView.contentOffset.y < -self.config.menuHeight) {
                        [scrollView setContentOffset:CGPointMake(0, -self.config.menuHeight) animated:NO];
                    }
                }

            } else {
                CGFloat scrollMenuViewDeltaY = _scrollMenuViewOriginY - scrollMenuViewY;
                    scrollMenuViewDeltaY = -_insetTop +  scrollMenuViewDeltaY;
                    /// 求出偏移了多少 未悬浮 (多个ScrollView偏移量联动)
                    [scrollView setContentOffset:CGPointMake(0, scrollMenuViewDeltaY) animated:NO];
            }
        }
        /// 设置TableView内容偏移
        scrollView.contentInset = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
        
        if ([self isSuspensionBottomStyle]) {
            scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
        }
        
    }
    /// 缓存控制器
    if (![self.cacheDictM objectForKey:title]) {
        [self.cacheDictM setObject:viewController forKey:title];
    }
}
#pragma mark - UIScrollViewDelegate

/// scrollView滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self replaceHeaderViewFromView];
    [self removeViewController];
    [self.scrollMenuView adjustItemPositionWithCurrentIndex:self.pageIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
        [self.delegate pageViewController:self didEndDecelerating:scrollView];
    }
    
}
/// scrollView滚动ing
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentPostion = scrollView.contentOffset.x;

    CGFloat offsetX = currentPostion / kYNPAGE_SCREEN_WIDTH;

    CGFloat offX = currentPostion > self.lastPositionX ? ceilf(offsetX) : offsetX;

    [self replaceHeaderViewFromTableView];
    
    [self initViewControllerWithIndex:offX];

    CGFloat progress = offsetX - (NSInteger)offsetX;

    self.lastPositionX = currentPostion;

    [self.scrollMenuView adjustItemWithProgress:progress lastIndex:floor(offsetX) currentIndex:ceilf(offsetX)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScroll:progress:formIndex:toIndex:)]) {
        [self.delegate pageViewController:self didScroll:scrollView progress:progress formIndex:floor(offsetX) toIndex:ceilf(offsetX)];
    }
    
}

#pragma mark - Yn_pageScrollViewDidScrollView
- (void)yn_pageScrollViewDidScrollView:(UIScrollView *)scrollView {
    
    if ([self isSuspensionBottomStyle] || [self isSuspensionTopStyle]) {
        if (!_headerViewInTableView) return;
        
        if (scrollView != self.currentScrollView) return;
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY < -_insetTop) {
            if ([self isSuspensionBottomStyle]) {
                self.headerBgView.yn_y = offsetY;
            }
        } else {
            self.headerBgView.yn_y = -_insetTop;
        }
        
        if (offsetY > - self.scrollMenuView.yn_height) {
            self.scrollMenuView.yn_y = offsetY;
            self.supendStatus = YES;
        } else {
            self.scrollMenuView.yn_y = self.headerBgView.yn_bottom;
            self.supendStatus = NO;
        }
        
        [self invokeDelegateForScrollWithOffsetY:offsetY];
        
        [self headerScaleWithOffsetY:offsetY];
    }
}

#pragma mark - YNPageScrollMenuViewDelegate
- (void)pagescrollMenuViewItemOnClick:(UILabel *)label index:(NSInteger)index {
    
    [self setSelectedPageIndex:index];
}

- (void)pagescrollMenuViewAddButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didAddButtonAction:)]) {
        [self.delegate pageViewController:self didAddButtonAction:button];
    }
}

#pragma mark - Public Method
- (void)setSelectedPageIndex:(NSInteger)pageIndex {
    
    if (self.cacheDictM.count > 0 && pageIndex == self.pageIndex) return;
    
    if (pageIndex > self.controllersM.count - 1) return;
    
    CGRect frame = CGRectMake(self.pageScrollView.yn_width * pageIndex, 0, self.pageScrollView.yn_width, self.pageScrollView.yn_height);
    
    [self.pageScrollView scrollRectToVisible:frame animated:NO];

    [self scrollViewDidEndDecelerating:self.pageScrollView];
    
}

- (void)addPageChildControllersWithTitles:(NSArray *)titles
                              controllers:(NSArray *)controllers
                                    index:(NSInteger)index {
    index = index < 0 ? 0 : index;
    index = index > self.controllersM.count - 1 ? self.controllersM.count - 1 : index;
    
    if (titles.count == controllers.count && controllers.count > 0) {
        [self.controllersM addObjectsFromArray:controllers];
        [self.titlesM addObjectsFromArray:titles];
    }
    
}

- (void)removePageControllerWithTtitle:(NSString *)title {
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.titlesM.count; i++) {
        if ([self.titlesM[i] isEqualToString:title]) {
            index = i;
            break;
        }
    }
    if (index == -1) return;
    [self removePageControllerWithIndex:index];
    
}

- (void)removePageControllerWithIndex:(NSInteger)index {
    
    if (index < 0 || index >= self.titlesM.count || self.titlesM.count == 1) return;
    if (self.pageIndex >= index) {
        self.pageIndex--;
        if (self.pageIndex < 0) {
            self.pageIndex = 0 ;
        }
    }
    [self.titlesM removeObject:self.titlesM[index]];
    [self.controllersM removeObject:self.controllersM[index]];
    [self setSelectedPageIndex:self.pageIndex];
}

- (void)replaceTitleArray:(NSMutableArray *)titleArray {
    
    NSMutableArray *resultViewControllerArray = @[].mutableCopy;
    for (NSInteger i = 0; i < titleArray.count; i++) {
        NSString * titleI = titleArray[i];
        for (NSInteger j = 0; j < self.titlesM.count; j++) {
            NSString *titleJ = self.titlesM[j];
            if ([titleI isEqualToString:titleJ]) {
                [resultViewControllerArray addObject:self.controllersM[j]];
                break;
            }
        }
    }
    self.titlesM = titleArray;
    self.controllersM = resultViewControllerArray;
}

#pragma mark - Private Method

- (void)initData {
    
    [self checkParams];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _headerViewInTableView = YES;

    _scrollMenuViewOriginY = _headerView.yn_height;
    
}
/// 初始化子View
- (void)setupSubViews {
    
    [self setupPageScrollMenuView];
    [self setupPageScrollView];

}

/// 初始化PageScrollView
- (void)setupPageScrollView {
    
    [self.view addSubview:self.pageScrollView];
    
    CGFloat navHeight = self.config.showNavigation ? kYNPAGE_NAVHEIGHT : 0;
    CGFloat tabHeight = self.config.showTabbar ? kYNPAGE_TABBARHEIGHT : 0;
    
    CGFloat contentHeight = kYNPAGE_SCREEN_HEIGHT - navHeight - tabHeight;
    
    self.pageScrollView.frame = CGRectMake(0, [self isTopStyle] ? self.config.menuHeight : 0, kYNPAGE_SCREEN_WIDTH, ([self isTopStyle] ? contentHeight - self.config.menuHeight : contentHeight));
    
    self.pageScrollView.contentSize = CGSizeMake(kYNPAGE_SCREEN_WIDTH * self.controllersM.count, contentHeight - ([self isTopStyle] ? self.config.menuHeight : 0));
    
}

/// 初始化ScrollView
- (void)setupPageScrollMenuView {
    [self initPagescrollMenuViewWithFrame:CGRectMake(0, 0, self.config.menuWidth, self.config.menuHeight)];
}

- (void)setupHeaderBgView {
    if ([self isSuspensionBottomStyle] || [self isSuspensionTopStyle]) {
        NSAssert(self.headerView, @"Please set headerView !");
        
        self.headerBgView = [[YNPageHeaderScrollView alloc] initWithFrame:self.headerView.bounds];
        self.headerBgView.contentSize = CGSizeMake(kYNPAGE_SCREEN_WIDTH * 2, self.headerView.yn_height);
        [self.headerBgView addSubview:self.headerView];
        self.headerViewOriginHeight = self.headerBgView.yn_height;
        self.headerBgView.scrollEnabled = !self.config.headerViewCouldScrollPage;
        
        if (self.config.headerViewCouldScale && self.scaleBackgroundView) {
            [self.headerBgView insertSubview:self.scaleBackgroundView atIndex:0];
            self.scaleBackgroundView.userInteractionEnabled = NO;
        }
        self.config.tempTopHeight = self.headerBgView.yn_height + self.config.menuHeight;
    }
}

/// 将headerView 从 view 上 放置 tableview 上
- (void)replaceHeaderViewFromView {
    if ([self isSuspensionBottomStyle] || [self isSuspensionTopStyle]) {
        if (!_headerViewInTableView) {
            
            UIScrollView *scrollView = self.currentScrollView;
            
            CGFloat headerViewY = [self.headerBgView.superview convertRect:self.headerBgView.frame toView:scrollView].origin.y;
            CGFloat scrollMenuViewY = [self.scrollMenuView.superview convertRect:self.scrollMenuView.frame toView:scrollView].origin.y;
            
            [self.headerBgView removeFromSuperview];
            [self.scrollMenuView removeFromSuperview];

            self.headerBgView.yn_y = headerViewY;
            self.scrollMenuView.yn_y = scrollMenuViewY;
            
            [scrollView addSubview:self.headerBgView];
            [scrollView addSubview:self.scrollMenuView];
            
            _headerViewInTableView = YES;
        }
    }
}

/// 将headerView 从 tableview 上 放置 view 上
- (void)replaceHeaderViewFromTableView {
    if ([self isSuspensionBottomStyle] || [self isSuspensionTopStyle]) {
        if (_headerViewInTableView) {
            
            CGFloat headerViewY = [self.headerBgView.superview convertRect:self.headerBgView.frame toView:self.pageScrollView].origin.y;
            CGFloat scrollMenuViewY = [self.scrollMenuView.superview convertRect:self.scrollMenuView.frame toView:self.pageScrollView].origin.y;
            
            [self.headerBgView removeFromSuperview];
            [self.scrollMenuView removeFromSuperview];
            self.headerBgView.yn_y = headerViewY;
            self.scrollMenuView.yn_y = scrollMenuViewY;
            
            [self.view addSubview:self.headerBgView];
            [self.view addSubview:self.scrollMenuView];
            
            _headerViewInTableView = NO;
        }
    }
}
/// 移除缓存控制器
- (void)removeViewController {
    for (int i = 0; i < self.controllersM.count; i ++) {
        if (i != self.pageIndex) {
            NSString *title = [self titleWithIndex:i];
            if(self.displayDictM[title]){
                [self removeViewControllerWithChildVC:self.displayDictM[title] index:i];
            }
        }
    }
}
/// 从父类控制器移除控制器
- (void)removeViewControllerWithChildVC:(UIViewController *)childVC index:(NSInteger)index {
    
    [self removeViewControllerWithChildVC:childVC];
    
    NSString *title = [self titleWithIndex:index];
    
    [self.displayDictM removeObjectForKey:title];
    
    if (![self.cacheDictM objectForKey:title]) {
        [self.cacheDictM setObject:childVC forKey:title];
    }
}

/// 添加子控制器
- (void)addChildViewControllerWithChildVC:(UIViewController *)childVC parentVC:(UIViewController *)parentVC {
    [parentVC addChildViewController:childVC];
    [parentVC didMoveToParentViewController:childVC];
    [parentVC.view addSubview:childVC.view];
}

/// 子控制器移除自己
- (void)removeViewControllerWithChildVC:(UIViewController *)childVC {
    [childVC.view removeFromSuperview];
    [childVC willMoveToParentViewController:nil];
    [childVC removeFromParentViewController];
}

/// 检查参数
- (void)checkParams {
    
    NSAssert(self.controllersM.count != 0 || self.controllersM, @"ViewControllers`count is 0 or nil");
    
    NSAssert(self.titlesM.count != 0 || self.titlesM, @"TitleArray`count is 0 or nil,");
    
    NSAssert(self.controllersM.count == self.titlesM.count, @"ViewControllers`count is not equal titleArray!");
    
    BOOL isHasNotEqualTitle = YES;
    for (int i = 0; i < self.titlesM.count; i++) {
        for (int j = i + 1; j < self.titlesM.count; j++) {
            if (i != j && [self.titlesM[i] isEqualToString:self.titlesM[j]]) {
                isHasNotEqualTitle = NO;
                break;
            }
        }
    }
    NSAssert(isHasNotEqualTitle, @"TitleArray Not allow equal title.");
    
    [self setupHeaderBgView];
}
#pragma mark - 样式取值
- (BOOL)isTopStyle {
    return self.config.pageStyle == YNPageStyleTop ? YES : NO;
}

- (BOOL)isNavigationStyle {
    return self.config.pageStyle == YNPageStyleNavigation ? YES : NO;
}

- (BOOL)isSuspensionTopStyle {
    return self.config.pageStyle == YNPageStyleSuspensionTop;
}

- (BOOL)isSuspensionBottomStyle {
    return self.config.pageStyle == YNPageStyleSuspensionCenter;
}

- (NSString *)titleWithIndex:(NSInteger)index {
    return  self.titlesM[index];
}
#pragma mark - Invoke Delegate Method
/// 回调监听列表滚动代理
- (void)invokeDelegateForScrollWithOffsetY:(CGFloat)offsetY {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:contentOffsetY:progress:)]) {
        CGFloat progress = 1 + (offsetY + self.scrollMenuView.yn_height) / (self.headerBgView.yn_height);
        [self.delegate pageViewController:self contentOffsetY:offsetY progress:progress > 1 ? 1 : progress];
    }
}


#pragma mark - Lazy Method
- (YNPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[YNPageScrollView alloc] init];
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _pageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _pageScrollView;
}

- (UIScrollView *)currentScrollView {
    return [self getScrollViewWithPageIndex:self.pageIndex];
}

- (UIScrollView *)getScrollViewWithPageIndex:(NSInteger)pageIndex {
    
    UIScrollView *scrollView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:pageForIndex:)]) {
        scrollView = [self.dataSource pageViewController:self pageForIndex:pageIndex];
        scrollView.yn_observerDidScrollView = YES;
        __weak typeof(self) weakSelf = self;
        scrollView.yn_pageScrollViewDidScrollView = ^(UIScrollView *scrollView) {
            [weakSelf yn_pageScrollViewDidScrollView:scrollView];
        };
        if (@available(iOS 11.0, *)) {
            if (scrollView) {
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }
    NSAssert(scrollView != nil, @"请设置pageViewController 的数据源！");
    return scrollView;
}

/// 出来头部伸缩
- (void)headerScaleWithOffsetY:(CGFloat)offsetY {
    
    if (self.config.headerViewCouldScale && self.scaleBackgroundView) {
        CGFloat yOffset  = offsetY + _insetTop;
        CGFloat xOffset = (yOffset) / 2;
        CGRect headerBgViewFrame = self.headerBgView.frame;
        CGRect scaleBgViewFrame = self.scaleBackgroundView.frame;
        if (self.config.headerViewScaleMode == YNPageHeaderViewScaleModeTop) {
            if (yOffset < 0) {
                headerBgViewFrame.origin.y = yOffset - _insetTop;
                headerBgViewFrame.size.height = -yOffset + self.headerViewOriginHeight;
                
                scaleBgViewFrame.size.height = -yOffset + self.headerViewOriginHeight;
                scaleBgViewFrame.origin.x = xOffset;
                scaleBgViewFrame.size.width = kYNPAGE_SCREEN_WIDTH + fabs(xOffset) * 2;
            }
        } else {
            if (yOffset < 0) {
                headerBgViewFrame.origin.y = yOffset - _insetTop;
                headerBgViewFrame.size.height = fabs(yOffset) + self.headerViewOriginHeight;
                
                scaleBgViewFrame.size.height = fabs(yOffset) + self.headerViewOriginHeight;
                scaleBgViewFrame.origin.x = xOffset;
                scaleBgViewFrame.size.width = kYNPAGE_SCREEN_WIDTH + fabs(xOffset) * 2;
            }
        }
        self.headerBgView.frame = headerBgViewFrame;
        self.scaleBackgroundView.frame = scaleBgViewFrame;
    }
    
}

- (void)dealloc {
#if DEBUG
    NSLog(@"----%@----dealloc", [self class]);
#endif
}

@end
