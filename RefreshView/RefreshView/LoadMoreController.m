//
//  LoadMoreContrller.m
//  RefreshView
//
//  Created by ileo on 15/6/10.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "LoadMoreController.h"

@interface LoadMoreController()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LoadMoreController

-(void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView.panGestureRecognizer removeTarget:self action:@selector(handleScrollViewDrag:)];
}

-(instancetype)initWithScrollView:(UIScrollView *)scrollView{
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        self.isLoading = NO;
        self.canAutoLoadTop = YES;
        self.canAutoLoadBottom = YES;
        
        [self.scrollView addObserver:self
                          forKeyPath:@"contentOffset"
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                             context:NULL];
        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(handleScrollViewDrag:)];
        [self.scrollView addObserver:self
                          forKeyPath:@"contentSize"
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                             context:NULL];
    }
    return self;
}

-(void)setLoadTopView:(LoadMoreView *)loadTopView{

    if (_loadTopView && [self.scrollView.subviews containsObject:_loadTopView]) {
        [_loadTopView removeFromSuperview];
    }
    _loadTopView = loadTopView;
    CGRect rect = _loadTopView.frame;
    rect.origin.y = -rect.size.height;
    _loadTopView.frame = rect;
    [self.scrollView addSubview:_loadTopView];

}

-(void)setLoadBottomView:(LoadMoreView *)loadBottomView{

    if (_loadBottomView && [self.scrollView.subviews containsObject:_loadBottomView]) {
        [_loadBottomView removeFromSuperview];
    }
    _loadBottomView = loadBottomView;
    CGRect rect = _loadBottomView.frame;
    rect.origin.y = self.scrollView.contentSize.height;
    _loadBottomView.frame = rect;
    [self.scrollView addSubview:_loadBottomView];
    
}

-(void)showLoadTop{
    if (self.loadTopView) {
        self.isLoading = YES;
        self.loadTopView.status = Load_Loading;
        [self.scrollView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.loadTopView.frame)) animated:YES];
    }
}

-(void)disappearLoadTop{
    self.loadTopView.status = Load_LoadingDone;
    [self animationToNormal];
    self.isLoading = NO;
}

-(void)disappearLoadBottom{
    self.loadBottomView.status = Load_LoadingDone;
    [self animationToNormal];
    self.isLoading = NO;
}

#pragma mark - top
-(void)loadMoreTop{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTopFinish:)]) {
        self.isLoading = YES;
        self.loadTopView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreTopFinish:^(CGFloat insetHeight) {
            [wself loadTopFinishWithInsetHeight:insetHeight];
        }];
    }
}
-(void)loadTopFinishWithInsetHeight:(CGFloat)insetHeight{
    self.loadTopView.status = Load_LoadingDone;
    CGFloat top = self.scrollView.contentInset.top;
    if (insetHeight != 0) {
        CGPoint offset = CGPointMake(0,
                                     (top == 0 ?
                                      insetHeight + self.scrollView.contentOffset.y
                                      : insetHeight - top));
        [self.scrollView setContentOffset:offset];
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }else if (top != 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(animationToNormal) userInfo:nil repeats:NO];
    }
    self.isLoading = NO;
}

#pragma mark - bottom
-(void)loadMoreBottom{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreBottomFinish:)]) {
        self.isLoading = YES;
        self.loadBottomView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreBottomFinish:^{
            [wself loadBottomFinish];
        }];
    }
}
-(void)loadBottomFinish{
    self.loadBottomView.status = Load_LoadingDone;
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(animationToNormal) userInfo:nil repeats:NO];
    self.isLoading = NO;
}

#pragma mark - kvc
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.scrollView) {
        if ([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
            return;
        }
        if ([keyPath isEqualToString:@"contentSize"]) {
            if (self.loadBottomView) {
                CGRect rect = self.loadBottomView.frame;
                rect.origin.y = self.scrollView.contentSize.height;
                self.loadBottomView.frame = rect;
            }
        }else if ([keyPath isEqualToString:@"contentOffset"]){
            [self scrollViewDidScroll];
        }
    }
}

-(void)scrollViewDidScroll{
    CGFloat y = self.scrollView.contentOffset.y;
    if (y < 0 && self.loadTopView) {
//top
        y = MAX(y, -CGRectGetHeight(self.loadTopView.frame));
        UIEdgeInsets inset = UIEdgeInsetsMake(-y, 0, 0, 0);
        if (self.canAutoLoadTop) {
            [self loadMoreTop];
        }else{
            if (!self.isLoading) {
                if (inset.top == CGRectGetHeight(self.loadTopView.frame)) {
                    self.loadTopView.status = Load_ShouldLoad;
                }else{
                    self.loadTopView.status = Load_Pulling;
                }
                inset.top = 0;
            }
        }
        if (inset.top != self.scrollView.contentInset.top) {
            __weak __typeof(self) wself = self;
            [UIView animateWithDuration:0.1 animations:^{
                wself.scrollView.contentInset = inset;
            }];
        }
    }else if (y+CGRectGetHeight(self.scrollView.frame) > self.scrollView.contentSize.height && self.loadBottomView) {
//bottom
        y = y + CGRectGetHeight(self.scrollView.frame) - self.scrollView.contentSize.height;
        y = MIN(y, CGRectGetHeight(self.loadBottomView.frame));
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, y, 0);
        if (self.canAutoLoadBottom) {
            [self loadMoreBottom];
        }else{
            if (!self.isLoading) {
                if (inset.bottom == CGRectGetHeight(self.loadBottomView.frame)) {
                    self.loadBottomView.status = Load_ShouldLoad;
                }else{
                    self.loadBottomView.status = Load_Pulling;
                }
            }
        }
        self.scrollView.contentInset = inset;
    }else if (self.scrollView.contentInset.top != 0 || self.scrollView.contentInset.bottom != 0){
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - pan

-(void)handleScrollViewDrag:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateRecognized) {
        [self scrollViewDidEndDrag];
    }
}
-(void)scrollViewDidEndDrag{
    CGFloat y = self.scrollView.contentOffset.y;
    if (![self canLoadWithCurrentVelocity]) return;
    if (self.loadTopView &&
        !self.canAutoLoadTop &&
        y <= -CGRectGetHeight(self.loadTopView.frame)) {
//top
        [self loadMoreTop];
    }else if (self.loadBottomView &&
              !self.canAutoLoadBottom &&
              (y + CGRectGetHeight(self.scrollView.frame)) >= (CGRectGetHeight(self.loadBottomView.frame) + self.scrollView.contentSize.height)) {
//bottom
        [self loadMoreBottom];
    }
}

-(BOOL)canLoadWithCurrentVelocity{
    CGFloat velocityY = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView].y;
    return velocityY < 1000 && velocityY > -1000;
}

#pragma mark - animation
-(void)animationToNormal{
    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:0.15 animations:^{
        wself.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}


@end
