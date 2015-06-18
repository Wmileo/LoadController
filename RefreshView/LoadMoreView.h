//
//  LoadMoreView.h
//  RefreshView
//
//  Created by ileo on 15/6/17.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Load_Status){
    Load_Loading = 1,
    Load_LoadingDone,
    Load_Pulling,
    Load_ShouldLoad,
};

@interface LoadMoreView : UIView

@property (nonatomic, assign) Load_Status status;

#pragma mark - 如果自定义的话 不用管这些属性
@property (nonatomic, strong) UIActivityIndicatorView *waitView;
@property (nonatomic, strong) UILabel *tipsL;
@property (nonatomic, copy) NSString *tipsPulling;
@property (nonatomic, copy) NSString *tipsShouldLoad;
@property (nonatomic, copy) NSString *tipsLoading;
@property (nonatomic, copy) NSString *tipsLoadingDone;

#pragma mark - 自定义需重写以下方法 按需重写
-(void)showLoadingView;
-(void)showPullingView;
-(void)showShouldLoadView;
-(void)showLoadingDoneView;

@end
