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
        self.canAutoLoadLeft = YES;
        self.canAutoLoadRight = YES;
        
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

#pragma mark - loadview
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

-(void)setLoadLeftView:(LoadMoreView *)loadLeftView{
    if (_loadLeftView && [self.scrollView.subviews containsObject:_loadLeftView]) {
        [_loadLeftView removeFromSuperview];
    }
    _loadLeftView = loadLeftView;
    CGRect rect = _loadLeftView.frame;
    rect.origin.x = -rect.size.width;
    _loadLeftView.frame = rect;
    [self.scrollView addSubview:_loadLeftView];
}

-(void)setLoadRightView:(LoadMoreView *)loadRightView{
    if (_loadRightView && [self.scrollView.subviews containsObject:_loadRightView]) {
        [_loadRightView removeFromSuperview];
    }
    _loadRightView = loadRightView;
    CGRect rect = _loadRightView.frame;
    rect.origin.x = self.scrollView.contentSize.width;
    _loadRightView.frame = rect;
    [self.scrollView addSubview:_loadRightView];
}

#pragma mark -
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

#pragma mark - left
-(void)loadMoreLeft{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreLeftFinish:)]) {
        self.isLoading = YES;
        self.loadLeftView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreLeftFinish:^(CGFloat insetWidth) {
            [wself loadLeftFinishWithInsetWidth:insetWidth];
        }];
    }
}

-(void)loadLeftFinishWithInsetWidth:(CGFloat)insetWidth{
    self.loadLeftView.status = Load_LoadingDone;
    CGFloat left = self.scrollView.contentInset.left;
    if (insetWidth != 0) {
        CGPoint offset = CGPointMake((left == 0 ? insetWidth + self.scrollView.contentOffset.x : insetWidth - left), 0);
        [self.scrollView setContentOffset:offset];
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }else if (left != 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(animationToNormal) userInfo:nil repeats:NO];
    }
    self.isLoading = NO;
}

#pragma mark - right
-(void)loadMoreRight{
    if (!self.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreRightFinish:)]) {
        self.isLoading = YES;
        self.loadRightView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreRightFinish:^{
            [wself loadRightFinish];
        }];
    }
}
-(void)loadRightFinish{
    self.loadRightView.status = Load_LoadingDone;
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
            if (self.loadRightView) {
                CGRect rect = self.loadRightView.frame;
                rect.origin.x = self.scrollView.contentSize.width;
                self.loadRightView.frame = rect;
            }
        }else if ([keyPath isEqualToString:@"contentOffset"]){
            [self scrollViewDidScroll];
        }
    }
}

-(void)scrollViewDidScroll{
    CGFloat y = self.scrollView.contentOffset.y;
    CGFloat x = self.scrollView.contentOffset.x;
    
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
    
    
    if (x < 0 && self.loadLeftView) {
//left
        x = MAX(x, -CGRectGetWidth(self.loadLeftView.frame));
        UIEdgeInsets inset = UIEdgeInsetsMake(0, -x, 0, 0);
        if (self.canAutoLoadLeft) {
            [self loadMoreLeft];
        }else{
            if (!self.isLoading) {
                if (inset.left == CGRectGetWidth(self.loadLeftView.frame)) {
                    self.loadLeftView.status = Load_ShouldLoad;
                }else{
                    self.loadLeftView.status = Load_Pulling;
                }
                inset.left = 0;
            }
        }
        if (inset.left != self.scrollView.contentInset.left) {
            __weak __typeof(self) wself = self;
            [UIView animateWithDuration:0.1 animations:^{
                wself.scrollView.contentInset = inset;
            }];
        }
    }else if (x+CGRectGetWidth(self.scrollView.frame) > self.scrollView.contentSize.width && self.loadRightView) {
//right
        x = x + CGRectGetWidth(self.scrollView.frame) - self.scrollView.contentSize.width;
        x = MIN(x, CGRectGetWidth(self.loadRightView.frame));
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, x);
        if (self.canAutoLoadRight) {
            [self loadMoreRight];
        }else{
            if (!self.isLoading) {
                if (inset.right == CGRectGetWidth(self.loadRightView.frame)) {
                    self.loadRightView.status = Load_ShouldLoad;
                }else{
                    self.loadRightView.status = Load_Pulling;
                }
            }
        }
        self.scrollView.contentInset = inset;
    }else if (self.scrollView.contentInset.left != 0 || self.scrollView.contentInset.right != 0){
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
    if ([self canLoadWithCurrentVelocityY]) {
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
    
    CGFloat x = self.scrollView.contentOffset.x;
    if ([self canLoadWithCurrentVelocityX]) {
        if (self.loadLeftView &&
            !self.canAutoLoadLeft &&
            x <= -CGRectGetWidth(self.loadLeftView.frame)) {
            //left
            [self loadMoreLeft];
        }else if (self.loadRightView &&
                  !self.canAutoLoadRight &&
                  (x + CGRectGetWidth(self.scrollView.frame)) >= (CGRectGetWidth(self.loadRightView.frame) + self.scrollView.contentSize.width)) {
            //right
            [self loadMoreRight];
        }
    }

}

-(BOOL)canLoadWithCurrentVelocityY{
    CGFloat velocityY = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView].y;
    return velocityY < 1000 && velocityY > -1000;
}

-(BOOL)canLoadWithCurrentVelocityX{
    CGFloat velocityX = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView].x;
    return velocityX < 1000 && velocityX > -1000;
}

#pragma mark - animation
-(void)animationToNormal{
    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:0.15 animations:^{
        wself.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}


@end
