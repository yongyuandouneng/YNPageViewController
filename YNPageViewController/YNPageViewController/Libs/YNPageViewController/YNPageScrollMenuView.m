//
//  YNPageScrollMenuView.m
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
#import "YNPageScrollView.h"
#import "UIView+YNPageExtend.h"

#define kYNPageScrollMenuViewConverMarginX 5

#define kYNPageScrollMenuViewConverMarginW 10

@interface YNPageScrollMenuView ()
/// line指示器
@property (nonatomic, strong) UIView *lineView;
/// 蒙层
@property (nonatomic, strong) UIView *converView;
/// ScrollView
@property (nonatomic, strong) YNPageScrollView *scrollView;
/// Add按钮
@property (nonatomic, strong) UIButton *addButton;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 标题数组
@property (nonatomic, copy) NSArray *titles;
/// 配置信息
@property (nonatomic, strong) YNPageConfigration *configration;
/// 代理
@property (nonatomic, weak) id<YNPageScrollMenuViewDelegate> delegate;
/// 上次index
@property (nonatomic, assign) NSInteger lastIndex;
/// 当前index
@property (nonatomic, assign) NSInteger currentIndex;
/// items
@property (nonatomic, strong) NSMutableArray *itemsArrayM;
/// item宽度
@property (nonatomic, strong) NSMutableArray *itemsWidthArraM;

@end

@implementation YNPageScrollMenuView

#pragma mark - Init Method

+ (instancetype)pagescrollMenuViewWithFrame:(CGRect)frame
                                     titles:(NSArray *)titles
                               configration:(YNPageConfigration *)configration
                                   delegate:(id<YNPageScrollMenuViewDelegate>)delegate
                               currentIndex:(NSInteger)currentIndex {
    
    frame.size.height = configration.menuHeight;
    frame.size.width = configration.menuWidth;
    
    YNPageScrollMenuView *menuView = [[YNPageScrollMenuView alloc] initWithFrame:frame];
    menuView.titles = titles;
    menuView.delegate = delegate;
    menuView.configration = configration ?: [YNPageConfigration defaultConfig];
    menuView.currentIndex = currentIndex;
    menuView.itemsArrayM = @[].mutableCopy;
    menuView.itemsWidthArraM = @[].mutableCopy;
    
    [menuView setupSubViews];
    return menuView;
}


#pragma mark - Private Method
- (void)setupSubViews {
    
    [self setupItems];
    [self setupOtherViews];
}

- (void)setupItems {
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.font = self.configration.itemFont;
        itemLabel.textColor = self.configration.normalItemColor;
        itemLabel.text = title;
        itemLabel.tag = idx;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.userInteractionEnabled = YES;
        
        [itemLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemLabelTapOnClick:)]];
        
        CGFloat width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName : self.configration.selectedItemFont} context:nil].size.width;
        
        [self.itemsWidthArraM addObject:@(width)];
        [self.itemsArrayM addObject:itemLabel];
        [self.scrollView addSubview:itemLabel];
    }];
}

- (void)setupOtherViews {
    
    self.scrollView.frame = CGRectMake(0, 0, self.configration.showAddButton ? self.yn_width - self.yn_height : self.yn_width, self.yn_height);
    
    [self addSubview:self.scrollView];
    
    if (self.configration.showAddButton) {
        self.addButton.frame = CGRectMake(self.yn_width - self.yn_height, 0, self.yn_height, self.yn_height);
        [self addSubview:self.addButton];
    }
    
    /// item
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    __block CGFloat itemW = 0;
    __block CGFloat itemH = self.yn_height - self.configration.lineHeight;
    
    [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            itemX += self.configration.itemLeftAndRightMargin;
        }else{
            itemX += self.configration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
        }
        label.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
    }];
    
    CGFloat scrollSizeWidht = self.configration.itemLeftAndRightMargin + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]);
    if (scrollSizeWidht < self.scrollView.yn_width) {//不超出宽度
        itemX = 0;
        itemY = 0;
        itemW = 0;
        
        CGFloat left = 0;
        
        for (NSNumber *width in self.itemsWidthArraM) {
            left += [width floatValue];
        }
        
        left = (self.scrollView.yn_width - left - self.configration.itemMargin * (self.itemsWidthArraM.count-1)) * 0.5;
        /// 居中且有剩余间距
        if (self.configration.aligmentModeCenter && left >= 0) {
            [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel  * label, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (idx == 0) {
                    itemX += left;
                }else{
                    itemX += self.configration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
                }
                label.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
            }];
            
            self.scrollView.contentSize = CGSizeMake(left + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
            
        } else { /// 否则按原来样子
            /// 不能滚动则平分
            if (!self.configration.scrollMenu) {
                [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel  * label, NSUInteger idx, BOOL * _Nonnull stop) {
                    itemW = self.scrollView.yn_width / self.itemsArrayM.count;
                    itemX = itemW *idx;
                    label.frame = CGRectMake(itemX, itemY, itemW, itemH);
                }];
                
                self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
                
            } else {
                self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.yn_height);
            }
        }
    } else { /// 大于scrollView的width·
        self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.yn_height);
    }
    
    CGFloat lineX = [(UILabel *)[self.itemsArrayM firstObject] yn_x];
    CGFloat lineY = self.scrollView.yn_height - self.configration.lineHeight;
    CGFloat lineW = [[self.itemsArrayM firstObject] yn_width];
    CGFloat lineH = self.configration.lineHeight;
    
    if (!self.configration.scrollMenu &&
        !self.configration.aligmentModeCenter &&
        self.configration.lineWidthEqualFontWidth) { ///处理Line宽度等于字体宽度
        lineX = [(UILabel *)[self.itemsArrayM firstObject] yn_x] + ([[self.itemsArrayM firstObject] yn_width]  - ([self.itemsWidthArraM.firstObject floatValue])) / 2;
        lineW = [self.itemsWidthArraM.firstObject floatValue];
    }
    
    /// conver
    if (self.configration.showConver) {
        self.converView.frame = CGRectMake(lineX - kYNPageScrollMenuViewConverMarginX, (self.scrollView.yn_height - self.configration.converHeight - self.configration.lineHeight) * 0.5, lineW + kYNPageScrollMenuViewConverMarginW, self.configration.converHeight);
        [self.scrollView insertSubview:self.converView atIndex:0];
    }
    /// bottomline
    if (self.configration.showBottomLine) {
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = self.configration.bottomLineBgColor;
        self.bottomLine.frame = CGRectMake(self.configration.bottomLineLeftAndRightMargin, self.scrollView.yn_height - self.configration.bottomLineHeight, self.scrollView.yn_width - 2 * self.configration.bottomLineLeftAndRightMargin, self.configration.bottomLineHeight);
        self.bottomLine.layer.cornerRadius = self.configration.bottomLineCorner;
        [self.scrollView addSubview:self.bottomLine];
    }
    
    if (self.configration.showScrollLine) {
        self.lineView.frame = CGRectMake(lineX - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin, lineY - self.configration.lineBottomMargin, lineW + self.configration.lineLeftAndRightAddWidth * 2 - 2 * self.configration.lineLeftAndRightMargin, lineH);
        self.lineView.layer.cornerRadius = self.configration.lineCorner;
        [self.scrollView addSubview:self.lineView];
    }
    
    if (self.configration.itemMaxScale > 1) {
        ((UILabel *)self.itemsArrayM[0]).transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
    }
    
    [self setDefaultTheme];
    
    [self selectedItemIndex:self.currentIndex animated:NO];
    
}

- (void)setDefaultTheme {
    
    UILabel *currentLabel = self.itemsArrayM[self.currentIndex];
    
    /// 缩放
    if (self.configration.itemMaxScale > 1) {
        currentLabel.transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
    }
    
    /// 颜色
    currentLabel.textColor = self.configration.selectedItemColor;
    currentLabel.font = self.configration.selectedItemFont;
    /// 线条
    if (self.configration.showScrollLine) {
        self.lineView.yn_x = currentLabel.yn_x - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin;
        self.lineView.yn_width = currentLabel.yn_width + self.configration.lineLeftAndRightAddWidth *2 - self.configration.lineLeftAndRightMargin * 2;
        
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { /// 处理Line宽度等于字体宽度
            self.lineView.yn_x = currentLabel.yn_x + ([currentLabel yn_width]  - ([self.itemsWidthArraM[currentLabel.tag] floatValue])) / 2 - self.configration.lineLeftAndRightAddWidth - self.configration.lineLeftAndRightAddWidth;
            self.lineView.yn_width = [self.itemsWidthArraM[currentLabel.tag] floatValue] + self.configration.lineLeftAndRightAddWidth *2;
        }
    }
    /// 遮盖
    if (self.configration.showConver) {
        self.converView.yn_x = currentLabel.yn_x - kYNPageScrollMenuViewConverMarginX;
        self.converView.yn_width = currentLabel.yn_width +kYNPageScrollMenuViewConverMarginW;
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { ///处理conver宽度等于字体宽度
            
            self.converView.yn_x = currentLabel.yn_x + ([currentLabel yn_width]  - ([self.itemsWidthArraM[currentLabel.tag] floatValue])) / 2 - kYNPageScrollMenuViewConverMarginX;
            self.converView.yn_width = [self.itemsWidthArraM[currentLabel.tag] floatValue] + kYNPageScrollMenuViewConverMarginW;
        }
    }
    
    self.lastIndex = self.currentIndex;
}

- (void)adjustItemAnimate:(BOOL)animated {
    
    UILabel *lastLabel = self.itemsArrayM[self.lastIndex];
    UILabel *currentLabel = self.itemsArrayM[self.currentIndex];
    
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        /// 缩放
        if (self.configration.itemMaxScale > 1) {
            lastLabel.transform = CGAffineTransformMakeScale(1, 1);
            currentLabel.transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
        }
        /// 颜色
        [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.textColor = self.configration.normalItemColor;
            obj.font = self.configration.itemFont;
            if (idx == self.itemsArrayM.count - 1) {
                currentLabel.textColor = self.configration.selectedItemColor;
                currentLabel.font = self.configration.selectedItemFont;
            }
        }];
        
        /// 线条
        if (self.configration.showScrollLine) {
            self.lineView.yn_x = currentLabel.yn_x - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin;
            self.lineView.yn_width = currentLabel.yn_width + self.configration.lineLeftAndRightAddWidth * 2 - 2 * self.configration.lineLeftAndRightMargin;
            
            if (!self.configration.scrollMenu &&
                !self.configration.aligmentModeCenter &&
                self.configration.lineWidthEqualFontWidth) {//处理Line宽度等于字体宽度
                
                self.lineView.yn_x = currentLabel.yn_x + ([currentLabel yn_width]  - ([self.itemsWidthArraM[currentLabel.tag] floatValue])) / 2 - self.configration.lineLeftAndRightAddWidth;;
                self.lineView.yn_width = [self.itemsWidthArraM[currentLabel.tag] floatValue] + self.configration.lineLeftAndRightAddWidth *2;
            }
            
        }
        /// 遮盖
        if (self.configration.showConver) {
            self.converView.yn_x = currentLabel.yn_x - kYNPageScrollMenuViewConverMarginX;
            self.converView.yn_width = currentLabel.yn_width +kYNPageScrollMenuViewConverMarginW;
            
            if (!self.configration.scrollMenu&&!self.configration.aligmentModeCenter&&self.configration.lineWidthEqualFontWidth) { /// 处理conver宽度等于字体宽度
                
                self.converView.yn_x = currentLabel.yn_x + ([currentLabel yn_width]  - ([self.itemsWidthArraM[currentLabel.tag] floatValue])) / 2  - kYNPageScrollMenuViewConverMarginX;
                self.converView.yn_width = [self.itemsWidthArraM[currentLabel.tag] floatValue] +kYNPageScrollMenuViewConverMarginW;
            }
        }
        
        self.lastIndex = self.currentIndex;
        
        
    }completion:^(BOOL finished) {
        [self adjustItemPositionWithCurrentIndex:self.currentIndex];
    }];
    
    
}
#pragma mark - Public Method
- (void)adjustItemPositionWithCurrentIndex:(NSInteger)index {
    
    if (self.scrollView.contentSize.width != self.scrollView.yn_width + 20) {
        
        UILabel *label = self.itemsArrayM[index];
        
        CGFloat offSex = label.center.x - self.scrollView.yn_width * 0.5;
        
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
    UILabel *lastLabel = self.itemsArrayM[self.lastIndex];
    UILabel *currentLabel = self.itemsArrayM[self.currentIndex];
    
    /// 缩放系数
    if (self.configration.itemMaxScale > 1) {
        CGFloat scaleB = self.configration.itemMaxScale - self.configration.deltaScale * progress;
        CGFloat scaleS = 1 + self.configration.deltaScale * progress;
        lastLabel.transform = CGAffineTransformMakeScale(scaleB, scaleB);
        currentLabel.transform = CGAffineTransformMakeScale(scaleS, scaleS);
    }
    
    if (self.configration.showGradientColor) {
        
        /// 颜色渐变
        [self.configration setRGBWithProgress:progress];
        
        lastLabel.textColor = [UIColor colorWithRed:self.configration.deltaNorR green:self.configration.deltaNorG blue:self.configration.deltaNorB alpha:1];
        
        currentLabel.textColor = [UIColor colorWithRed:self.configration.deltaSelR green:self.configration.deltaSelG blue:self.configration.deltaSelB alpha:1];
    } else{
        if (progress > 0.5) {
            lastLabel.textColor = self.configration.normalItemColor;
            currentLabel.textColor = self.configration.selectedItemColor;
            currentLabel.font = self.configration.selectedItemFont;
            
        } else if (progress < 0.5 && progress > 0){
            lastLabel.textColor = self.configration.selectedItemColor;
            lastLabel.font = self.configration.selectedItemFont;
            
            currentLabel.textColor = self.configration.normalItemColor;
            currentLabel.font = self.configration.itemFont;
            
        }
    }
    
    if (progress > 0.5) {
        lastLabel.font = self.configration.itemFont;
        currentLabel.font = self.configration.selectedItemFont;
    } else if (progress < 0.5 && progress > 0){
        lastLabel.font = self.configration.selectedItemFont;
        currentLabel.font = self.configration.itemFont;
    }
    
    CGFloat xD = currentLabel.yn_x - lastLabel.yn_x;
    CGFloat wD = currentLabel.yn_width - lastLabel.yn_width;
    
    /// 线条
    if (self.configration.showScrollLine) {
        self.lineView.yn_x = lastLabel.yn_x + xD *progress - self.configration.lineLeftAndRightAddWidth + self.configration.lineLeftAndRightMargin;
        self.lineView.yn_width = lastLabel.yn_width + wD *progress + self.configration.lineLeftAndRightAddWidth *2 - 2 * self.configration.lineLeftAndRightMargin;
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { /// 处理Line宽度等于字体宽度
            self.lineView.yn_x = lastLabel.yn_x + ([lastLabel yn_width]  - ([self.itemsWidthArraM[lastLabel.tag] floatValue])) / 2 - self.configration.lineLeftAndRightAddWidth + xD *progress;
            self.lineView.yn_width = [self.itemsWidthArraM[lastLabel.tag] floatValue] + self.configration.lineLeftAndRightAddWidth *2 + wD *progress;
        }
        
    }
    /// 遮盖
    if (self.configration.showConver) {
        self.converView.yn_x = lastLabel.yn_x + xD *progress - kYNPageScrollMenuViewConverMarginX;
        self.converView.yn_width = lastLabel.yn_width  + wD *progress + kYNPageScrollMenuViewConverMarginW;
        
        if (!self.configration.scrollMenu &&
            !self.configration.aligmentModeCenter &&
            self.configration.lineWidthEqualFontWidth) { /// 处理cover宽度等于字体宽度
            self.converView.yn_x = lastLabel.yn_x + ([lastLabel yn_width]  - ([self.itemsWidthArraM[lastLabel.tag] floatValue])) / 2 -  kYNPageScrollMenuViewConverMarginX + xD *progress;
            self.converView.yn_width = [self.itemsWidthArraM[lastLabel.tag] floatValue] + kYNPageScrollMenuViewConverMarginW + wD *progress;
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
        _lineView.backgroundColor = self.configration.lineColor;
    }
    return _lineView;
}

- (UIView *)converView {
    if (!_converView) {
        _converView = [[UIView alloc] init];
        _converView.layer.backgroundColor = self.configration.converColor.CGColor;
        _converView.layer.cornerRadius = self.configration.coverCornerRadius;
        _converView.layer.masksToBounds = YES;
        _converView.userInteractionEnabled = NO;
    }
    return _converView;
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[YNPageScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = self.configration.bounces;
        _scrollView.backgroundColor = self.configration.scrollViewBackgroundColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = self.configration.scrollMenu;
    }
    return _scrollView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.configration.addButtonNormalImageName] forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.configration.addButtonHightImageName] forState:UIControlStateHighlighted];
        _addButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _addButton.layer.shadowOffset = CGSizeMake(-1, 0);
        _addButton.layer.shadowOpacity = 0.5;
        _addButton.backgroundColor = self.configration.addButtonBackgroundColor;
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - itemLabelTapOnClick

- (void)itemLabelTapOnClick:(UITapGestureRecognizer *)tapGresture {
    
    UILabel *label = (UILabel *)tapGresture.view;
    
    self.currentIndex= label.tag;
    
    [self adjustItemWithAnimated:YES];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pagescrollMenuViewItemOnClick:index:)]) {
        [self.delegate pagescrollMenuViewItemOnClick:label index:self.lastIndex];
    }
    
}

#pragma mark -  addButtonAction

- (void)addButtonAction:(UIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(pagescrollMenuViewAddButtonAction:)]){
        [self.delegate pagescrollMenuViewAddButtonAction:button];
    }
}

@end
