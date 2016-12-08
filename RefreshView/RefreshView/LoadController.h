//
//  LoadContrller.h
//  RefreshView
//
//  Created by ileo on 15/6/10.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoadView.h"

@protocol LoadControllerDelegate <NSObject>

@optional
-(void)loadTopFinish:(void (^)(CGFloat insetHeight))finish withScrollView:(UIScrollView *)scrollView;
-(void)loadBottomFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView;

-(void)loadLeftFinish:(void (^)(CGFloat insetWidth))finish withScrollView:(UIScrollView *)scrollView;
-(void)loadRightFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView;
@end

@interface LoadController : NSObject

//设置对应的加载界面  设置时即开启加载功能
@property (nonatomic, strong) LoadView *loadTopView;
@property (nonatomic, strong) LoadView *loadBottomView;
@property (nonatomic, strong) LoadView *loadLeftView;
@property (nonatomic, strong) LoadView *loadRightView;

@property (nonatomic, assign) id<LoadControllerDelegate> delegate;

-(instancetype)initWithScrollView:(UIScrollView *)scrollView;

//
-(void)disappearLoadBottom;
-(void)showLoadTop;
-(void)disappearLoadTop;

@end
