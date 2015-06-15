//
//  LoadMoreContrller.h
//  RefreshView
//
//  Created by ileo on 15/6/10.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LoadMoreControllerDelegate <NSObject>

@optional
-(void)loadMoreTopFinish:(void (^)(CGFloat insetHeight))finish;
-(void)loadMoreBottomFinish:(void (^)())finish;

@end

@interface LoadMoreController : NSObject

@property (nonatomic, strong) UIView *loadTopView;
@property (nonatomic, strong) UIView *loadBottomView;
@property (nonatomic, assign) id<LoadMoreControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isLoading;

//yes:当滑动到一定距离时自动加载 no:只有拖动到一定距离时才加载
@property (nonatomic, assign) BOOL canAutoLoadTop;
@property (nonatomic, assign) BOOL canAutoLoadBottom;

-(instancetype)initWithScrollView:(UIScrollView *)scrollView;

#pragma mark -
-(void)disappearLoadBottom;
-(void)showLoadTop;
-(void)disappearLoadTop;


@end
