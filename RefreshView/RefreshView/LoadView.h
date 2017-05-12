//
//  LoadMoreView.h
//  RefreshView
//
//  Created by ileo on 15/6/17.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Load_Status){
    Load_Loading = 10,
    Load_LoadingDone,
    Load_Pulling,
    Load_ShouldLoad,
};

@protocol LoadView <NSObject>

#pragma mark - 自定义需重写以下方法 按需重写
-(void)showLoadingView;
-(void)showPullingView;
-(void)showShouldLoadView;
-(void)showLoadingDoneView;

@end


@interface LoadView : UIView <LoadView>

@property (nonatomic, assign) Load_Status status;
@property (nonatomic, assign) CGFloat offset;//拉出的距离

@property (nonatomic, readonly) UIScrollView *superScrollView;

#pragma mark - 状态
@property (nonatomic, readonly) BOOL isLoading;
//yes:当滑动到一定距离时自动加载 no:只有拖动到一定距离时才加载
@property (nonatomic, assign) BOOL canAutoLoad;
//是否加载完整  加载完整就不再检测位移
@property (nonatomic, assign) BOOL isLoadComplete;

#pragma mark - 加载完恢复动画时间
@property (nonatomic, assign) double recoverDuration;//默认0.15
@property (nonatomic, assign) double recoverDelay;//默认0.4

#pragma mark - 如果自定义的话 不用管这些属性
@property (nonatomic, strong) UIActivityIndicatorView *waitView;
@property (nonatomic, strong) UILabel *tipsL;
@property (nonatomic, copy) NSString *tipsPulling;
@property (nonatomic, copy) NSString *tipsShouldLoad;
@property (nonatomic, copy) NSString *tipsLoading;
@property (nonatomic, copy) NSString *tipsLoadingDone;
@property (nonatomic, assign) BOOL autoHideTips;//自动关闭提示
-(void)hideTips;//隐藏Tips

@end
