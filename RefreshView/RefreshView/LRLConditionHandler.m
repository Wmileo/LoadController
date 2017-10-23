//
//  LRLConditionHandler.m
//  RefreshView
//
//  Created by leo on 2017/10/14.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import "LRLConditionHandler.h"



@implementation LRLConditionHandler

-(void)dealloc{

}

-(BOOL)canHandleScrollTop{
    if ([self canHandleScrollWithLoadView:self.loadTopView]) {
        return self.scrollView.contentOffset.y + self.normalContentInset.top < 0;
    }
    return NO;
}

-(BOOL)canHandleScrollBottom{
    if ([self canHandleScrollWithLoadView:self.loadBottomView]) {
        return self.scrollView.contentOffset.y + CGRectGetHeight(self.scrollView.frame) > self.scrollView.contentSize.height;
    }
    return NO;
}

-(BOOL)canHandleScrollLeft{
    if ([self canHandleScrollWithLoadView:self.loadLeftView]) {
        return self.scrollView.contentOffset.x + self.normalContentInset.left < 0;
    }
    return NO;
}

-(BOOL)canHandleScrollRight{
    if ([self canHandleScrollWithLoadView:self.loadRightView]) {
        return self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame) > self.scrollView.contentSize.width;
    }
    return NO;
}

//没判断位移
-(BOOL)canHandleScrollWithLoadView:(LoadView *)loadView{
    if (!loadView) {
        return NO;
    }
    return !loadView.isLoadComplete;
}

#pragma mark - 手指结束滑动后是否满足加载条件
-(BOOL)canLoadTopWhenEndDrag{
    if ([self canLoadWhenEndDragWithLoadView:self.loadTopView direction:LRLDirection_Vertical]) {
        CGFloat y = self.scrollView.contentOffset.y + self.normalContentInset.top;
        return (y <= -CGRectGetHeight(self.loadTopView.frame));
    }
    return NO;
}

-(BOOL)canLoadBottomWhenEndDrag{
    if ([self canLoadWhenEndDragWithLoadView:self.loadBottomView direction:LRLDirection_Vertical]) {
        CGFloat y = self.scrollView.contentOffset.y;
        return (y + CGRectGetHeight(self.scrollView.frame)) >= (CGRectGetHeight(self.loadBottomView.frame) + self.scrollView.contentSize.height);
    }
    return NO;
}

-(BOOL)canLoadLeftWhenEndDrag{
    if ([self canLoadWhenEndDragWithLoadView:self.loadLeftView direction:LRLDirection_Horizontal]) {
        CGFloat x = self.scrollView.contentOffset.x + self.normalContentInset.left;
        return (x <= -CGRectGetWidth(self.loadLeftView.frame));
    }
    return NO;
}

-(BOOL)canLoadRightWhenEndDrag{
    if ([self canLoadWhenEndDragWithLoadView:self.loadRightView direction:LRLDirection_Horizontal]) {
        CGFloat x = self.scrollView.contentOffset.x;
        return (x + CGRectGetWidth(self.scrollView.frame)) >= (CGRectGetWidth(self.loadRightView.frame) + self.scrollView.contentSize.width);
    }
    return NO;
}

//没判断位移
-(BOOL)canLoadWhenEndDragWithLoadView:(LoadView *)loadView direction:(LRLDirection)direction{
    if (!loadView) {
        return NO;
    }
    if ((loadView.loadShouldPause && [self canLoadWhenEndDragWithCurrentVelocityWithDirection:direction]) || !loadView.loadShouldPause) {
        return !loadView.isLoadComplete && !loadView.canAutoLoad;
    }
    return NO;
}

//只判断速度
-(BOOL)canLoadWhenEndDragWithCurrentVelocityWithDirection:(LRLDirection)direction{
    CGPoint velocityPoint = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView];
    CGFloat velocity = direction == LRLDirection_Horizontal ? velocityPoint.x : velocityPoint.y;
    return velocity < 1000 && velocity > -1000;
}


#pragma mark - loading

-(BOOL)isLoading{
    return (self.loadTopView && self.loadTopView.isLoading) ||
    (self.loadBottomView && self.loadBottomView.isLoading) ||
    (self.loadLeftView && self.loadLeftView.isLoading) ||
    (self.loadRightView && self.loadRightView.isLoading);
}

@end
