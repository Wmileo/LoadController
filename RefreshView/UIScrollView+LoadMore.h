//
//  UIScrollView+LoadMore.h
//  RefreshView
//
//  Created by ileo on 16/3/22.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreController.h"

@interface UIScrollView (LoadMore)

@property (nonatomic, strong) LoadMoreController *loadMoreController;

-(void)setLoadMoreDelegate:(id<LoadMoreControllerDelegate>)loadMoreDelegate;

-(void)setLoadMoreTopView:(LoadMoreView *)loadMoreView;
-(void)setLoadMoreBottomView:(LoadMoreView *)loadMoreView;
-(void)setLoadMoreLeftView:(LoadMoreView *)loadMoreView;
-(void)setLoadMoreRightView:(LoadMoreView *)loadMoreView;

@end
