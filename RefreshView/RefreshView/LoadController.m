//
//  LoadContrller.m
//  RefreshView
//
//  Created by ileo on 15/6/10.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "LoadController.h"
#import "LRLFrameHandler.h"
#import "LRLConditionHandler.h"
#import "LRLContentHandler.h"

@interface LoadController()

@property (nonatomic, weak) UIScrollView *loadScrollView;

@property (nonatomic, strong) LRLFrameHandler *frameHandler;
@property (nonatomic, strong) LRLConditionHandler *conditionHandler;
@property (nonatomic, strong) LRLContentHandler *contentHandler;

@end

@implementation LoadController

-(void)dealloc{
    [self clearScrollView:self.scrollView];
}

-(void)clearScrollView:(UIScrollView *)scrollView{
    [self.frameHandler clearScrollView:scrollView];
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [scrollView.panGestureRecognizer removeTarget:self action:@selector(handleScrollViewDrag:)];
}

-(instancetype)initWithScrollView:(UIScrollView *)scrollView{
    self = [super init];
    if (self) {
        self.loadScrollView = scrollView;
        self.normalContentInset = scrollView.contentInset;
        [self.scrollView addObserver:self
                          forKeyPath:@"contentOffset"
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                             context:NULL];
        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(handleScrollViewDrag:)];
        
        self.frameHandler = [[LRLFrameHandler alloc] initWithLoadController:self];
        self.conditionHandler = [[LRLConditionHandler alloc] initWithLoadController:self];
        self.contentHandler = [[LRLContentHandler alloc] initWithLoadController:self];
    }
    return self;
}

-(UIScrollView *)scrollView{
    return self.loadScrollView;
}

#pragma mark -
-(void)showLoadTop{
    if (self.loadTopView) {
        self.loadTopView.status = Load_Loading;
        [self.scrollView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.loadTopView.frame)) animated:YES];
    }
}

-(void)disappearLoadTop{
    [self loadFinishWithLoadView:self.loadTopView];
}

-(void)disappearLoadBottom{
    [self loadFinishWithLoadView:self.loadBottomView];
}

#pragma mark - top
-(void)loadTop{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadTopFinish:withScrollView:)]) {
        self.loadTopView.status = Load_Loading;
        __weak __typeof(self) wself = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate loadTopFinish:^(CGFloat insetHeight) {
                [wself loadTopFinishWithInsetHeight:insetHeight];
            } withScrollView:wself.scrollView];
//        });
    }
}
-(void)loadTopFinishWithInsetHeight:(CGFloat)insetHeight{
    CGFloat top = self.scrollView.contentInset.top;
    if (insetHeight != 0) {
        CGPoint offset = CGPointMake(0,
                                     (top == 0 ?
                                      insetHeight + self.scrollView.contentOffset.y
                                      : insetHeight - top));
        [self.scrollView setContentOffset:offset];
        self.scrollView.contentInset = self.normalContentInset;
        self.loadTopView.status = Load_LoadingDone;
    }else{
        [self loadFinishWithLoadView:self.loadTopView];
    }
}

#pragma mark - bottom
-(void)loadBottom{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadBottomFinish:withScrollView:)]) {
        self.loadBottomView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadBottomFinish:^{
            [wself loadFinishWithLoadView:wself.loadBottomView];
        } withScrollView:self.scrollView];
    }
}

#pragma mark - left
-(void)loadLeft{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadLeftFinish:withScrollView:)]) {
        self.loadLeftView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadLeftFinish:^(CGFloat insetWidth) {
            [wself loadLeftFinishWithInsetWidth:insetWidth];
        } withScrollView:self.scrollView];
    }
}

-(void)loadLeftFinishWithInsetWidth:(CGFloat)insetWidth{
    CGFloat left = self.scrollView.contentInset.left;
    if (insetWidth != 0) {
        CGPoint offset = CGPointMake((left == 0 ? insetWidth + self.scrollView.contentOffset.x : insetWidth - left), 0);
        [self.scrollView setContentOffset:offset];
        self.scrollView.contentInset = self.normalContentInset;
        self.loadLeftView.status = Load_LoadingDone;
    }else if (left != 0) {
        [self loadFinishWithLoadView:self.loadLeftView];
    }
}

#pragma mark - right
-(void)loadRight{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadRightFinish:withScrollView:)]) {
        self.loadRightView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadRightFinish:^{
            [wself loadFinishWithLoadView:wself.loadRightView];
        } withScrollView:self.scrollView];
    }
}

#pragma mark - kvc
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.scrollView) {
        if ([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
            return;
        }
        if ([keyPath isEqualToString:@"contentOffset"]){
            [self scrollViewDidScroll];
        }
    }
}

-(void)scrollViewDidScroll{

    if ([self.conditionHandler canHandleScrollTop]) {
        //top
        self.loadTopView.offset = [self.contentHandler offsetTop];
        UIEdgeInsets inset = [self.contentHandler insetWithOffsetTop];
        if (self.loadTopView.canAutoLoad) {
            [self loadTop];
        }else{
            if (!self.loadTopView.isLoading) {
                if (inset.top == CGRectGetHeight(self.loadTopView.frame) + self.normalContentInset.top) {
                    if (self.loadTopView.loadShouldPause) {
                        self.loadTopView.status = Load_ShouldLoad;
                        inset.top = self.normalContentInset.top;
                    }else{
                        if (self.loadTopView.status != Load_LoadingDone) {
                            self.loadTopView.status = Load_ShouldLoad;
                            if (!self.scrollView.isTracking) {
                                [self loadTop];
                            }else{
                                inset.top = self.normalContentInset.top;
                            }
                        }
                    }
                }else{
                    self.loadTopView.status = Load_Pulling;
                    inset.top = self.normalContentInset.top;
                }
            }
        }
        if (inset.top != self.normalContentInset.top) {
            [UIView animateWithDuration:0.1 animations:^{
                self.scrollView.contentInset = inset;
            }];
        }
        
    }else if ([self.conditionHandler canHandleScrollBottom]) {
        //bottom
        self.loadBottomView.offset = [self.contentHandler offsetBottom];
        UIEdgeInsets inset = [self.contentHandler insetWithOffsetBottom];
        if (self.loadBottomView.canAutoLoad) {
            [self loadBottom];
        }else{
            if (!self.loadBottomView.isLoading) {
                if (inset.bottom == CGRectGetHeight(self.loadBottomView.frame)) {
                    self.loadBottomView.status = Load_ShouldLoad;
                }else{
                    self.loadBottomView.status = Load_Pulling;
                }
//                inset.bottom = self.normalContentInset.bottom;
            }
        }
        self.scrollView.contentInset = inset;
    }else if (self.scrollView.contentInset.top != self.normalContentInset.top ||
              self.scrollView.contentInset.bottom != self.normalContentInset.bottom){
        self.scrollView.contentInset = self.normalContentInset;
    }
    
    if ([self.conditionHandler canHandleScrollLeft]) {
        //left
        self.loadLeftView.offset = [self.contentHandler offsetLeft];
        UIEdgeInsets inset = [self.contentHandler insetWithOffsetLeft];
        if (self.loadLeftView.canAutoLoad) {
            [self loadLeft];
        }else{
            if (!self.loadLeftView.isLoading) {
                if (inset.left == CGRectGetWidth(self.loadLeftView.frame) + self.normalContentInset.left) {
                    self.loadLeftView.status = Load_ShouldLoad;
                }else{
                    self.loadLeftView.status = Load_Pulling;
                }
                inset.left = self.normalContentInset.left;
            }
        }
        if (inset.left != self.scrollView.contentInset.left) {
            [UIView animateWithDuration:0.1 animations:^{//防止突变
                self.scrollView.contentInset = inset;
            }];
        }
    }else if ([self.conditionHandler canHandleScrollRight]) {
        //right
        self.loadRightView.offset = [self.contentHandler offsetRight];
        UIEdgeInsets inset = [self.contentHandler insetWithOffsetRight];
        if (self.loadRightView.canAutoLoad) {
            [self loadRight];
        }else{
            if (!self.loadRightView.isLoading) {
                if (inset.right == CGRectGetWidth(self.loadRightView.frame)) {
                    self.loadRightView.status = Load_ShouldLoad;
                }else{
                    self.loadRightView.status = Load_Pulling;
                }
//                inset.right = self.normalContentInset.right;
            }
        }
        self.scrollView.contentInset = inset;
    }else if (self.scrollView.contentInset.left != self.normalContentInset.left || self.scrollView.contentInset.right != self.normalContentInset.right){
        self.scrollView.contentInset = self.normalContentInset;
    }
}

#pragma mark - pan

-(void)handleScrollViewDrag:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateRecognized) {
        [self scrollViewDidEndDrag];
    }
}

-(void)scrollViewDidEndDrag{
    
    if ([self.conditionHandler canLoadTopWhenEndDrag]) {
        [self loadTop];
    }else if ([self.conditionHandler canLoadBottomWhenEndDrag]) {
        [self loadBottom];
    }
    
    if ([self.conditionHandler canLoadLeftWhenEndDrag]) {
        [self loadLeft];
    }else if ([self.conditionHandler canLoadRightWhenEndDrag]) {
        [self loadRight];
    }
    
}

#pragma mark - loading

-(BOOL)isLoading{
    return (self.loadTopView && self.loadTopView.isLoading) ||
    (self.loadBottomView && self.loadBottomView.isLoading) ||
    (self.loadLeftView && self.loadLeftView.isLoading) ||
    (self.loadRightView && self.loadRightView.isLoading);
}


#pragma mark - animation
-(void)loadFinishWithLoadView:(LoadView *)loadView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loadView.recoverDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak LoadView *wloadView = loadView;
        [self animationToNormalWithDuration:loadView.recoverDuration completion:^{
            wloadView.status = Load_LoadingDone;
        }];
    });
}

-(void)animationToNormalWithDuration:(double)duration completion:(void (^)())completion{
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = self.normalContentInset;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - loadview
-(void)setLoadTopView:(LoadView *)loadTopView{
    if (_loadTopView && [self.scrollView.subviews containsObject:_loadTopView]) {
        [_loadTopView removeFromSuperview];
    }
    _loadTopView = loadTopView;
    [self.scrollView addSubview:_loadTopView];
    _loadTopView.frame = [self.frameHandler createLoadTopViewFrame];
}

-(void)setLoadBottomView:(LoadView *)loadBottomView{
    if (_loadBottomView && [self.scrollView.subviews containsObject:_loadBottomView]) {
        [_loadBottomView removeFromSuperview];
    }
    _loadBottomView = loadBottomView;
    [self.scrollView addSubview:_loadBottomView];
    _loadBottomView.frame = [self.frameHandler createLoadBottomViewFrame];
}

-(void)setLoadLeftView:(LoadView *)loadLeftView{
    if (_loadLeftView && [self.scrollView.subviews containsObject:_loadLeftView]) {
        [_loadLeftView removeFromSuperview];
    }
    _loadLeftView = loadLeftView;
    [self.scrollView addSubview:_loadLeftView];
    _loadLeftView.frame = [self.frameHandler createLoadLeftViewFrame];
}

-(void)setLoadRightView:(LoadView *)loadRightView{
    if (_loadRightView && [self.scrollView.subviews containsObject:_loadRightView]) {
        [_loadRightView removeFromSuperview];
    }
    _loadRightView = loadRightView;
    [self.scrollView addSubview:_loadRightView];
    _loadRightView.frame = [self.frameHandler createLoadRightViewFrame];
}

@end
