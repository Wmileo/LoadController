//
//  UIScrollView+LoadMore.m
//  RefreshView
//
//  Created by ileo on 16/3/22.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import "UIScrollView+LoadMore.h"
#import <objc/runtime.h>

@implementation UIScrollView (LoadMore)

static char loadMoreControllerKey;

-(void)setLoadMoreDelegate:(id<LoadMoreControllerDelegate>)loadMoreDelegate{
    self.loadMoreController.delegate = loadMoreDelegate;
}

-(void)setLoadMoreController:(LoadMoreController *)loadMoreController{
    objc_setAssociatedObject(self, &loadMoreControllerKey, loadMoreController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(LoadMoreController *)loadMoreController{
    LoadMoreController *loadMore = objc_getAssociatedObject(self, &loadMoreControllerKey);
    if (!loadMore) {
        loadMore = [[LoadMoreController alloc] initWithScrollView:self];
        objc_setAssociatedObject(self, &loadMoreControllerKey, loadMore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return loadMore;
}

-(void)setLoadMoreTopView:(LoadMoreView *)loadMoreView{
    self.loadMoreController.loadTopView = loadMoreView;
}

-(void)setLoadMoreBottomView:(LoadMoreView *)loadMoreView{
    self.loadMoreController.loadBottomView = loadMoreView;
}

-(void)setLoadMoreLeftView:(LoadMoreView *)loadMoreView{
    self.loadMoreController.loadLeftView = loadMoreView;
}

-(void)setLoadMoreRightView:(LoadMoreView *)loadMoreView{
    self.loadMoreController.loadRightView = loadMoreView;
}

@end
