![image](http://paxdlrdk7.bkt.clouddn.com/name3.png)


![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/cocoapods/v/YNPageViewController.svg?style=flat)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)


## 集合了多种样式的嵌套页面布局(滑动库):
```本库是对```[YNPageScrollViewController](https://github.com/yongyuandouneng/YNPageScrollViewController) ```进行重构，优化代码，重写实现原理。其优点如下：```

|         | 优点  |
----------|-----------------
✅  | 易于集成，多种样式以供选择，特斯拉(悬浮)布局等
✅  | 控制器生命周期完好无损、懒加载控制器
✅  | 高性能:  用双缓存机制让界面只存在一个控制器
✅  | 支持UISollView、UITableView、UICollectionView、
✅    |  支持列表拓展tableFooterView、tableHeaderView、
✅  | 支持CollectionView的瀑布流、FlowLayout修改的布局
✅  | 支持头部拉伸放大特效、还有其他部分拓展的API


## Demo效果图

![image](http://paxdlrdk7.bkt.clouddn.com/YNPageViewControllerGif.gif)


## Requirements 要求
* iOS 8+
* Xcode 8+

## Installation 安装
#### 1.手动安装:
- `下载DEMO后,将子文件夹Libs/YNPageViewController拖入到项目中, 导入头文件YNPageViewController.h开始使用.`

#### 2.CocoaPods安装:

- `一、可以直接在项目Podfile 文件中 pod 'YNPageViewController'`

- `二、先pod search YNPageViewController 搜索一下`
- `如果发现pod search YNPageViewController 不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存,重新搜索`
- `搜索不到则执行1.pod repo update 2.rm ~/Library/Caches/CocoaPods/search_index.json`
- `在Podfile文件中用 pod 'YNPageViewController'`

## 使用方法
```
1.新建控制器继承YNPageViewController 实现 YNPageViewControllerDataSource, YNPageViewControllerDelegate, delegate可选实现
2.创建YNPageConfigration类进行配置信息
3.创建实例方法
+ (instancetype)pageViewControllerWithControllers:(NSArray *)controllers
                                           titles:(NSArray *)titles
                                           config:(YNPageConfigration *)config;
4.具体使用方法可以查看Demos教程。
```
## 使用悬浮样式需要注意:
```
• SuspensionTop || SuspensionCenter 需要填充cell占位高度，不支持 [mj_header beginRefresing]

• headerView高度较小建议使用 SuspensionTop，高度比较大建议使用 SuspensionCenter

• SuspensionTopPause不需要填充占位cell高度，只是头部上拉时停顿。可实现QQ联系人效果。

```
## CocoaPods更新日志

```
• 2018-12-13 (tag 0.2.5): 添加数据源获取列表高度，默认是控制器高度 

• 2018-07-27 (tag 0.1.3 ~ 0.1.7): 添加reloadData方法、自定义缓存Key可配置相同title、优化QQ联系人悬浮布局

• 2018-07-27 (tag 0.1.3): 新增置顶API, 插入、删除、调整顺序控制器的API

• 2018-07-23 (tag 0.1.2): 新增可以添加 ScrollMenu ButtonItem image

• 2018-07-14 (tag 0.1.0): 修复头部视图可侧滑返回

• 2018-07-14 (tag 0.0.9): 新增SuspensionTopPause样式和示例 (QQ联系人Tab布局)

• 2018-07-12 (tag 0.0.7): 解决 SectionHeader 挡住 ScrollMenu 的问题

• 2018-07-09 (tag 0.0.5): 新增悬浮Menu 偏移量

• 2018-07-03 (tag 0.0.3): 新增刷新悬浮头部视图高度API
  
• 2018-06-29 (tag 0.0.2):
  1.添加设置菜单栏选择字体大小属性
  2.修复拉倒底部点击菜单栏下掉问题
  
• 2018-06-27 (tag 0.0.1): 发布Pods v0.0.1
```
## 联系方式:

* Email : 1003580893@qq.com
* QQ群 : 538133294
* Blog  : https://www.yongyuandouneng.com

![YN-iOS-交流群群二维码](http://paxdlrdk7.bkt.clouddn.com/IMG_1052.JPG)

## 许可证
YNPageViewController 使用 MIT 许可证，详情见 LICENSE 文件。 
