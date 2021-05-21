//
//  YNPageScrollMenuView.m
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageScrollMenuView.h"
#import "YNPageConfiguration.h"
#import "YNPageScrollView.h"
#import "UIView+YNPageExtend.h"

#define kYNPageScrollMenuViewCoverMarginX 5

#define kYNPageScrollMenuViewCoverMarginW 10

@interface YNPageScrollMenuView ()

/// line指示器
@property (nonatomic, strong) UIView *lineView;
/// 蒙层
@property (nonatomic, strong) UIView *coverView;
/// ScrollView
@property (nonatomic, strong) YNPageScrollView *scrollView;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 配置信息
@property (nonatomic, strong) YNPageConfiguration *configuration;
/// 代理
@property (nonatomic, weak) id<YNPageScrollMenuViewDelegate> delegate;
/// 上次index
@property (nonatomic, assign) NSInteger lastIndex;
/// 当前index
@property (nonatomic, assign) NSInteger currentIndex;
/// items
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsArrayM;
/// item宽度
@property (nonatomic, strong) NSMutableArray *itemsWidthArraM;

@end

@implementation YNPageScrollMenuView

#pragma mark - Init Method

+ (instancetype)pageScrollMenuViewWithFrame:(CGRect)frame
                                     titles:(NSMutableArray *)titles
                               configuration:(YNPageConfiguration *)configuration
                                   delegate:(id<YNPageScrollMenuViewDelegate>)delegate
                               currentIndex:(NSInteger)currentIndex {
    frame.size.height = configuration.menuHeight;
    frame.size.width = configuration.menuWidth;
    
    YNPageScrollMenuView *menuView = [[YNPageScrollMenuView alloc] initWithFrame:frame];
    menuView.titles = titles;
    menuView.delegate = delegate;
    menuView.configuration = configuration ?: [YNPageConfiguration defaultConfig];
    menuView.currentIndex = currentIndex;
    menuView.itemsArrayM = @[].mutableCopy;
    menuView.itemsWidthArraM = @[].mutableCopy;
    
    [menuView setupSubViews];
    return menuView;
}

#pragma mark - Private Method
- (void)setupSubViews {
    self.backgroundColor = self.configuration.scrollViewBackgroundColor;
    [self setupItems];
    [self setupOtherViews];
}

- (void)setupItems {
    if (self.configuration.buttonArray.count > 0 && self.titles.count == self.configuration.buttonArray.count) {
        [self.configuration.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull itemButton, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setupButton:itemButton title:self.titles[idx] idx:idx];
        }];
    } else {
        [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self setupButton:itemButton title:title idx:idx];
        }];
    }
}

- (void)setupButton:(UIButton *)itemButton title:(NSString *)title idx:(NSInteger)idx {
    itemButton.titleLabel.font = self.configuration.selectedItemFont;
    [itemButton setTitleColor:self.configuration.normalItemColor forState:UIControlStateNormal];
    [itemButton setTitle:title forState:UIControlStateNormal];
    itemButton.tag = idx;
    [itemButton addTarget:self action:@selector(itemButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton sizeToFit];
    [self.itemsWidthArraM addObject:@(itemButton.yn_width)];
    [self.itemsArrayM addObject:itemButton];
    [self.scrollView addSubview:itemButton];
}

- (void)setupOtherViews {
    self.scrollView.frame = CGRectMake(0, 0, self.configuration.showAddButton ? self.yn_width - self.yn_height : self.yn_width, self.yn_height);
    [self addSubview:self.scrollView];
    if (self.configuration.showAddButton) {
        self.addButton.frame = CGRectMake(self.yn_width - self.yn_height, 0, self.yn_height, self.yn_height);
        [self addSubview:self.addButton];
    }
    
    /// item
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    __block CGFloat itemW = 0;
    __block CGFloat itemH = self.yn_height - self.configuration.lineHeight;
    
    [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            itemX += self.configuration.itemLeftAndRightMargin;
        }else{
            itemX += self.configuration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
        }
        button.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
    }];
    
    CGFloat scrollSizeWidth = self.configuration.itemLeftAndRightMargin + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]);
    if (scrollSizeWidth < self.scrollView.yn_width) {//不超出宽度
        itemX = 0;
        itemY = 0;
        itemW = 0;
        CGFloat left = 0;
        for (NSNumber *width in self.itemsWidthArraM) {
            left += [width floatValue];
        }
        
        left = (self.scrollView.yn_width - left - self.configuration.itemMargin * (self.itemsWidthArraM.count-1)) * 0.5;
        /// 居中且有剩余间距
        if (self.configuration.alignmentModeCenter && left >= 0) {
            [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton  * button, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (idx == 0) {
                    itemX += left;
                }else{
                    itemX += self.configuration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
                }
                button.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
            }];
            
            self.scrollView.contentSize = CGSizeMake(left + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
            
        } else {
            /// 不能滚动则平分
            if (!self.configuration.scrollMenu) {
                [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton  * button, NSUInteger idx, BOOL * _Nonnull stop) {
                    itemW = self.scrollView.yn_width / self.itemsArrayM.count;
                    itemX = itemW *idx;
                    button.frame = CGRectMake(itemX, itemY, itemW, itemH);
                }];
                
                self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
                
            } else {
                self.scrollView.contentSize = CGSizeMake(scrollSizeWidth, self.scrollView.yn_height);
            }
        }
    } else { /// 大于scrollView的width·
        self.scrollView.contentSize = CGSizeMake(scrollSizeWidth, self.scrollView.yn_height);
    }
    
    CGFloat lineX = [(UIButton *)[self.itemsArrayM firstObject] yn_x];
    CGFloat lineY = self.scrollView.yn_height - self.configuration.lineHeight;
    CGFloat lineW = [[self.itemsArrayM firstObject] yn_width];
    CGFloat lineH = self.configuration.lineHeight;
    
    /// 处理Line宽度等于字体宽度
    if (!self.configuration.scrollMenu &&
        !self.configuration.alignmentModeCenter &&
        self.configuration.lineWidthEqualFontWidth) {
        lineX = [(UIButton *)[self.itemsArrayM firstObject] yn_x] + ([[self.itemsArrayM firstObject] yn_width]  - ([self.itemsWidthArraM.firstObject floatValue])) / 2;
        lineW = [self.itemsWidthArraM.firstObject floatValue];
    }
    
    /// cover
    if (self.configuration.showCover) {
        self.coverView.frame = CGRectMake(lineX - kYNPageScrollMenuViewCoverMarginX, (self.scrollView.yn_height - self.configuration.coverHeight - self.configuration.lineHeight) * 0.5, lineW + kYNPageScrollMenuViewCoverMarginW, self.configuration.coverHeight);
        [self.scrollView insertSubview:self.coverView atIndex:0];
    }
    
    /// bottomLine
    if (self.configuration.showBottomLine) {
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = self.configuration.bottomLineBgColor;
        self.bottomLine.frame = CGRectMake(self.configuration.bottomLineLeftAndRightMargin, self.yn_height - self.configuration.bottomLineHeight, self.scrollView.yn_width - 2 * self.configuration.bottomLineLeftAndRightMargin, self.configuration.bottomLineHeight);
        self.bottomLine.layer.cornerRadius = self.configuration.bottomLineCorner;
        [self insertSubview:self.bottomLine atIndex:0];
    }
    
    /// scrollLine
    if (self.configuration.showScrollLine) {
        self.lineView.frame = CGRectMake(lineX - self.configuration.lineLeftAndRightAddWidth + self.configuration.lineLeftAndRightMargin, lineY - self.configuration.lineBottomMargin, lineW + self.configuration.lineLeftAndRightAddWidth * 2 - 2 * self.configuration.lineLeftAndRightMargin, lineH);
        self.lineView.layer.cornerRadius = self.configuration.lineCorner;
        [self.scrollView addSubview:self.lineView];
    }
    
    if (self.configuration.itemMaxScale > 1) {
        ((UIButton *)self.itemsArrayM[self.currentIndex]).transform = CGAffineTransformMakeScale(self.configuration.itemMaxScale, self.configuration.itemMaxScale);
    }
    [self setDefaultTheme];
    [self selectedItemIndex:self.currentIndex animated:NO];
}

- (void)setDefaultTheme {
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    /// 缩放
    if (self.configuration.itemMaxScale > 1) {
        currentButton.transform = CGAffineTransformMakeScale(self.configuration.itemMaxScale, self.configuration.itemMaxScale);
    }
    /// 颜色
    currentButton.selected = YES;
    [currentButton setTitleColor:self.configuration.selectedItemColor forState:UIControlStateNormal];
    currentButton.titleLabel.font = self.configuration.selectedItemFont;
    /// 线条
    if (self.configuration.showScrollLine) {
        self.lineView.yn_x = currentButton.yn_x - self.configuration.lineLeftAndRightAddWidth + self.configuration.lineLeftAndRightMargin;
        self.lineView.yn_width = currentButton.yn_width + self.configuration.lineLeftAndRightAddWidth *2 - self.configuration.lineLeftAndRightMargin * 2;
        /// 处理Line宽度等于字体宽度
        if (!self.configuration.scrollMenu &&
            !self.configuration.alignmentModeCenter &&
            self.configuration.lineWidthEqualFontWidth) {
            self.lineView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2 - self.configuration.lineLeftAndRightAddWidth - self.configuration.lineLeftAndRightAddWidth;
            self.lineView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] + self.configuration.lineLeftAndRightAddWidth *2;
        }
    }
    /// 遮盖
    if (self.configuration.showCover) {
        self.coverView.yn_x = currentButton.yn_x - kYNPageScrollMenuViewCoverMarginX;
        self.coverView.yn_width = currentButton.yn_width +kYNPageScrollMenuViewCoverMarginW;
        /// 处理cover宽度等于字体宽度
        if (!self.configuration.scrollMenu &&
            !self.configuration.alignmentModeCenter &&
            self.configuration.lineWidthEqualFontWidth) {
            self.coverView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2 - kYNPageScrollMenuViewCoverMarginX;
            self.coverView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] + kYNPageScrollMenuViewCoverMarginW;
        }
    }
    self.lastIndex = self.currentIndex;
}

- (void)adjustItemAnimate:(BOOL)animated {
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        /// 缩放
        if (self.configuration.itemMaxScale > 1) {
            lastButton.transform = CGAffineTransformMakeScale(1, 1);
            currentButton.transform = CGAffineTransformMakeScale(self.configuration.itemMaxScale, self.configuration.itemMaxScale);
        }
        /// 颜色
        [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            [obj setTitleColor:self.configuration.normalItemColor forState:UIControlStateNormal];
            obj.titleLabel.font = self.configuration.itemFont;
            if (idx == self.itemsArrayM.count - 1) {
               currentButton.selected = YES;
               [currentButton setTitleColor:self.configuration.selectedItemColor forState:UIControlStateNormal];
                currentButton.titleLabel.font = self.configuration.selectedItemFont;
            }
        }];
        
        /// 线条
        if (self.configuration.showScrollLine) {
            self.lineView.yn_x = currentButton.yn_x - self.configuration.lineLeftAndRightAddWidth + self.configuration.lineLeftAndRightMargin;
            self.lineView.yn_width = currentButton.yn_width + self.configuration.lineLeftAndRightAddWidth * 2 - 2 * self.configuration.lineLeftAndRightMargin;
            
            if (!self.configuration.scrollMenu &&
                !self.configuration.alignmentModeCenter &&
                self.configuration.lineWidthEqualFontWidth) {//处理Line宽度等于字体宽度
                
                self.lineView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2 - self.configuration.lineLeftAndRightAddWidth;;
                self.lineView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] + self.configuration.lineLeftAndRightAddWidth *2;
            }
        }
        /// 遮盖
        if (self.configuration.showCover) {
            self.coverView.yn_x = currentButton.yn_x - kYNPageScrollMenuViewCoverMarginX;
            self.coverView.yn_width = currentButton.yn_width +kYNPageScrollMenuViewCoverMarginW;
            /// 处理cover宽度等于字体宽度
            if (!self.configuration.scrollMenu&&!self.configuration.alignmentModeCenter&&self.configuration.lineWidthEqualFontWidth) {
                self.coverView.yn_x = currentButton.yn_x + ([currentButton yn_width]  - ([self.itemsWidthArraM[currentButton.tag] floatValue])) / 2  - kYNPageScrollMenuViewCoverMarginX;
                self.coverView.yn_width = [self.itemsWidthArraM[currentButton.tag] floatValue] +kYNPageScrollMenuViewCoverMarginW;
            }
        }
        self.lastIndex = self.currentIndex;
    } completion:^(BOOL finished) {
        [self adjustItemPositionWithCurrentIndex:self.currentIndex];
    }];
}

#pragma mark - Public Method
- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    if (index < 0 || index > self.titles.count - 1) return;
    if (title.length == 0) return;
    [self reloadView];
}

- (void)updateTitles:(NSArray *)titles {
    if (titles.count != self.titles.count) return;
    [self reloadView];
}

- (void)adjustItemPositionWithCurrentIndex:(NSInteger)index {
    if (self.scrollView.contentSize.width != self.scrollView.yn_width + 20) {
        
        UIButton *button = self.itemsArrayM[index];

        CGFloat offSex = button.center.x - self.scrollView.yn_width * 0.5;
        
        offSex = offSex > 0 ? offSex : 0;
        
        CGFloat maxOffSetX = self.scrollView.contentSize.width - self.scrollView.yn_width;
        
        maxOffSetX = maxOffSetX > 0 ? maxOffSetX : 0;
        
        offSex = offSex > maxOffSetX ? maxOffSetX : offSex;
        
        [self.scrollView setContentOffset:CGPointMake(offSex, 0) animated:YES];
    }
}

- (void)adjustItemWithProgress:(CGFloat)progress
                     lastIndex:(NSInteger)lastIndex
                  currentIndex:(NSInteger)currentIndex {
    self.lastIndex = lastIndex;
    self.currentIndex = currentIndex;
    
    if (lastIndex == currentIndex) return;
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    /// 缩放系数
    if (self.configuration.itemMaxScale > 1) {
        CGFloat scaleB = self.configuration.itemMaxScale - self.configuration.deltaScale * progress;
        CGFloat scaleS = 1 + self.configuration.deltaScale * progress;
        lastButton.transform = CGAffineTransformMakeScale(scaleB, scaleB);
        currentButton.transform = CGAffineTransformMakeScale(scaleS, scaleS);
    }
    
    if (self.configuration.showGradientColor) {
        /// 颜色渐变
        [self.configuration setRGBWithProgress:progress];
        UIColor *norColor = [UIColor colorWithRed:self.configuration.deltaNorR green:self.configuration.deltaNorG blue:self.configuration.deltaNorB alpha:1];
        UIColor *selColor = [UIColor colorWithRed:self.configuration.deltaSelR green:self.configuration.deltaSelG blue:self.configuration.deltaSelB alpha:1];
        [lastButton setTitleColor:norColor forState:UIControlStateNormal];
        [currentButton setTitleColor:selColor forState:UIControlStateNormal];
        
    } else {
        if (progress > 0.5) {
            lastButton.selected = NO;
            currentButton.selected = YES;
            [lastButton setTitleColor:self.configuration.normalItemColor forState:UIControlStateNormal];
            [currentButton setTitleColor:self.configuration.selectedItemColor forState:UIControlStateNormal];
            currentButton.titleLabel.font = self.configuration.selectedItemFont;
        } else if (progress < 0.5 && progress > 0){
            lastButton.selected = YES;
            [lastButton setTitleColor:self.configuration.selectedItemColor forState:UIControlStateNormal];
            lastButton.titleLabel.font = self.configuration.selectedItemFont;
            currentButton.selected = NO;
            [currentButton setTitleColor:self.configuration.normalItemColor forState:UIControlStateNormal];
            currentButton.titleLabel.font = self.configuration.itemFont;
        }
    }
    
    if (progress > 0.5) {
        lastButton.titleLabel.font = self.configuration.itemFont;
        currentButton.titleLabel.font = self.configuration.selectedItemFont;
    } else if (progress < 0.5 && progress > 0){
        lastButton.titleLabel.font = self.configuration.selectedItemFont;
        currentButton.titleLabel.font = self.configuration.itemFont;
    }
    
    CGFloat xD = 0;
    CGFloat wD = 0;
    if (!self.configuration.scrollMenu &&
        !self.configuration.alignmentModeCenter &&
        self.configuration.lineWidthEqualFontWidth) {
        xD = currentButton.titleLabel.yn_x + currentButton.yn_x -( lastButton.titleLabel.yn_x + lastButton.yn_x );
        wD = currentButton.titleLabel.yn_width - lastButton.titleLabel.yn_width;
    } else {
        xD = currentButton.yn_x - lastButton.yn_x;
        wD = currentButton.yn_width - lastButton.yn_width;
    }
    
    /// 线条
    if (self.configuration.showScrollLine) {
        
        if (!self.configuration.scrollMenu &&
            !self.configuration.alignmentModeCenter &&
            self.configuration.lineWidthEqualFontWidth) { /// 处理Line宽度等于字体宽度
            self.lineView.yn_x = lastButton.yn_x + ([lastButton yn_width]  - ([self.itemsWidthArraM[lastButton.tag] floatValue])) / 2 - self.configuration.lineLeftAndRightAddWidth + xD *progress;
            
            self.lineView.yn_width = [self.itemsWidthArraM[lastButton.tag] floatValue] + self.configuration.lineLeftAndRightAddWidth *2 + wD *progress;
            
        } else {
            self.lineView.yn_x = lastButton.yn_x + xD *progress - self.configuration.lineLeftAndRightAddWidth + self.configuration.lineLeftAndRightMargin;
            self.lineView.yn_width = lastButton.yn_width + wD *progress + self.configuration.lineLeftAndRightAddWidth *2 - 2 * self.configuration.lineLeftAndRightMargin;
        }
    }
    /// 遮盖
    if (self.configuration.showCover) {
        self.coverView.yn_x = lastButton.yn_x + xD *progress - kYNPageScrollMenuViewCoverMarginX;
        self.coverView.yn_width = lastButton.yn_width  + wD *progress + kYNPageScrollMenuViewCoverMarginW;
        
        if (!self.configuration.scrollMenu &&
            !self.configuration.alignmentModeCenter &&
            self.configuration.lineWidthEqualFontWidth) { /// 处理cover宽度等于字体宽度
            self.coverView.yn_x = lastButton.yn_x + ([lastButton yn_width]  - ([self.itemsWidthArraM[lastButton.tag] floatValue])) / 2 -  kYNPageScrollMenuViewCoverMarginX + xD *progress;
            self.coverView.yn_width = [self.itemsWidthArraM[lastButton.tag] floatValue] + kYNPageScrollMenuViewCoverMarginW + wD *progress;
        }
    }
}

- (void)selectedItemIndex:(NSInteger)index
                 animated:(BOOL)animated {
    self.currentIndex = index;
    [self adjustItemAnimate:animated];
}

- (void)adjustItemWithAnimated:(BOOL)animated {
    if (self.lastIndex == self.currentIndex) return;
    [self adjustItemAnimate:animated];
}

#pragma mark - Lazy Method
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = self.configuration.lineColor;
    }
    return _lineView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.layer.backgroundColor = self.configuration.coverColor.CGColor;
        _coverView.layer.cornerRadius = self.configuration.coverCornerRadius;
        _coverView.layer.masksToBounds = YES;
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[YNPageScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = self.configuration.bounces;;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = self.configuration.scrollMenu;
    }
    return _scrollView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.configuration.addButtonNormalImageName] forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.configuration.addButtonHightImageName] forState:UIControlStateHighlighted];
        _addButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _addButton.layer.shadowOffset = CGSizeMake(-1, 0);
        _addButton.layer.shadowOpacity = 0.5;
        _addButton.backgroundColor = self.configuration.addButtonBackgroundColor;
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - itemButtonTapOnClick
- (void)itemButtonOnClick:(UIButton *)button {
    self.currentIndex= button.tag;
    [self adjustItemWithAnimated:YES];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pageScrollMenuViewItemOnClick:index:)]) {
        [self.delegate pageScrollMenuViewItemOnClick:button index:self.lastIndex];
    }
}

- (void)reloadView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }

    [self.itemsArrayM removeAllObjects];
    [self.itemsWidthArraM removeAllObjects];
    [self setupSubViews];
}

#pragma mark -  addButtonAction
- (void)addButtonAction:(UIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollMenuViewAddButtonAction:)]){
        [self.delegate pageScrollMenuViewAddButtonAction:button];
    }
}

@end
