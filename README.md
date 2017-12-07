# LoadController

加载控制器，方便在UIScrollView添加滑动加载操作

## install

    pod 'LoadController'

## how to use

###### 第一步
导入头文件

    #import <UIScrollView+Load.h>

###### 第二步
自定义自己想要的LoadView 或者用默认的

>自定义需继承LoadView，重写以下方法，在对应状态显示你想要的效果

    -(void)showLoadingView;
    -(void)showPullingView;
    -(void)showShouldLoadView;
    -(void)showLoadingDoneView;
###### 第三步

设置对应要加载的区域

    @property (nonatomic, strong) LoadView *loadTopView;
    @property (nonatomic, strong) LoadView *loadBottomView;
    @property (nonatomic, strong) LoadView *loadLeftView;
    @property (nonatomic, strong) LoadView *loadRightView;

###### 第四步
设置代理，并实现对应的方法

    @property (nonatomic, weak) id<LoadControllerDelegate> loadDelegate;

    -(void)loadTopFinish:(void (^)(CGFloat insetHeight))finish withScrollView:(UIScrollView *)scrollView;
    -(void)loadBottomFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView;
    -(void)loadLeftFinish:(void (^)(CGFloat insetWidth))finish withScrollView:(UIScrollView *)scrollView;
    -(void)loadRightFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView;
###### Done
运行吧

## so easy
