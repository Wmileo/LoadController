//
//  LoadMoreContrller.h
//  RefreshView
//
//  Created by ileo on 15/6/10.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoadMoreView.h"

typedef NS_ENUM(NSInteger, Load_Direction){
    Load_Top,
    Load_Bottom,
    Load_Left,
    Load_Right,
};

@protocol LoadMoreControllerDelegate <NSObject>

@optional
-(void)loadMoreTopFinish:(void (^)(CGFloat insetHeight))finish withScrollView:(UIScrollView *)scrollView;
-(void)loadMoreBottomFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView;

-(void)loadMoreLeftFinish:(void (^)(CGFloat insetWidth))finish withScrollView:(UIScrollView *)scrollView;
-(void)loadMoreRightFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView;

@end

@interface LoadMoreController : NSObject

//设置对应的加载界面  设置时即开启加载功能
@property (nonatomic, strong) LoadMoreView *loadTopView;
@property (nonatomic, strong) LoadMoreView *loadBottomView;
@property (nonatomic, strong) LoadMoreView *loadLeftView;
@property (nonatomic, strong) LoadMoreView *loadRightView;

@property (nonatomic, assign) id<LoadMoreControllerDelegate> delegate;

//yes:当滑动到一定距离时自动加载 no:只有拖动到一定距离时才加载
@property (nonatomic, assign) BOOL canAutoLoadTop;
@property (nonatomic, assign) BOOL canAutoLoadBottom;
@property (nonatomic, assign) BOOL canAutoLoadLeft;
@property (nonatomic, assign) BOOL canAutoLoadRight;

-(instancetype)initWithScrollView:(UIScrollView *)scrollView;

//加载状态
@property (nonatomic, assign) BOOL isLoading;

-(void)setIsLoading:(BOOL)isLoading direction:(Load_Direction)direction afterTime:(NSTimeInterval)time;

-(void)disappearLoadBottom;
-(void)showLoadTop;
-(void)disappearLoadTop;


@end
