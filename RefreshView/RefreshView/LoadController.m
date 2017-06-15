//
//  LoadContrller.m
//  RefreshView
//
//  Created by ileo on 15/6/10.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#define TIMER_DURATION @"duration"

#import "LoadController.h"

@interface LoadController()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LoadController

-(void)dealloc{
    
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView.panGestureRecognizer removeTarget:self action:@selector(handleScrollViewDrag:)];
    
}

-(instancetype)initWithScrollView:(UIScrollView *)scrollView{
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
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
-(void)setLoadTopView:(LoadView *)loadTopView{

    if (_loadTopView && [self.scrollView.subviews containsObject:_loadTopView]) {
        [_loadTopView removeFromSuperview];
    }
    _loadTopView = loadTopView;
    CGRect rect = _loadTopView.frame;
    rect.origin.y = -rect.size.height;
    _loadTopView.frame = rect;
    [self.scrollView addSubview:_loadTopView];

}

-(void)setLoadBottomView:(LoadView *)loadBottomView{

    if (_loadBottomView && [self.scrollView.subviews containsObject:_loadBottomView]) {
        [_loadBottomView removeFromSuperview];
    }
    _loadBottomView = loadBottomView;
    CGRect rect = _loadBottomView.frame;
    rect.origin.y = self.scrollView.contentSize.height;
    _loadBottomView.frame = rect;
    [self.scrollView addSubview:_loadBottomView];
    
}

-(void)setLoadLeftView:(LoadView *)loadLeftView{
    if (_loadLeftView && [self.scrollView.subviews containsObject:_loadLeftView]) {
        [_loadLeftView removeFromSuperview];
    }
    _loadLeftView = loadLeftView;
    CGRect rect = _loadLeftView.frame;
    rect.origin.x = -rect.size.width;
    _loadLeftView.frame = rect;
    [self.scrollView addSubview:_loadLeftView];
}

-(void)setLoadRightView:(LoadView *)loadRightView{
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
        self.loadTopView.status = Load_Loading;
        [self.scrollView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.loadTopView.frame)) animated:YES];
    }
}

-(void)disappearLoadTop{
    self.loadTopView.status = Load_LoadingDone;
    [self animationToNormalWithDuration:self.loadTopView.recoverDuration];
}

-(void)disappearLoadBottom{
    self.loadBottomView.status = Load_LoadingDone;
    [self animationToNormalWithDuration:self.loadBottomView.recoverDuration];
}

#pragma mark - top
-(void)loadTop{
    if (!self.loadTopView.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadTopFinish:withScrollView:)]) {
        self.loadTopView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.delegate loadTopFinish:^(CGFloat insetHeight) {
                [wself loadTopFinishWithInsetHeight:insetHeight];
            } withScrollView:wself.scrollView];
        });
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
        [NSTimer scheduledTimerWithTimeInterval:self.loadTopView.recoverDelay target:self selector:@selector(animationToNormalTimer:) userInfo:@{TIMER_DURATION : @(self.loadTopView.recoverDuration)} repeats:NO];
    }
}

#pragma mark - bottom
-(void)loadBottom{
    if (!self.loadBottomView.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadBottomFinish:withScrollView:)]) {
        self.loadBottomView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadBottomFinish:^{
            [wself loadBottomFinish];
        } withScrollView:self.scrollView];
    }
}
-(void)loadBottomFinish{
    self.loadBottomView.status = Load_LoadingDone;
    [NSTimer scheduledTimerWithTimeInterval:self.loadBottomView.recoverDelay target:self selector:@selector(animationToNormalTimer:) userInfo:@{TIMER_DURATION : @(self.loadBottomView.recoverDuration)} repeats:NO];
}

#pragma mark - left
-(void)loadLeft{
    if (!self.loadLeftView.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadLeftFinish:withScrollView:)]) {
        self.loadLeftView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadLeftFinish:^(CGFloat insetWidth) {
            [wself loadLeftFinishWithInsetWidth:insetWidth];
        } withScrollView:self.scrollView];
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
        [NSTimer scheduledTimerWithTimeInterval:self.loadLeftView.recoverDelay target:self selector:@selector(animationToNormalTimer:) userInfo:@{TIMER_DURATION : @(self.loadLeftView.recoverDuration)} repeats:NO];
    }
}

#pragma mark - right
-(void)loadRight{
    if (!self.loadRightView.isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadRightFinish:withScrollView:)]) {
        self.loadRightView.status = Load_Loading;
        __weak __typeof(self) wself = self;
        [self.delegate loadRightFinish:^{
            [wself loadRightFinish];
        } withScrollView:self.scrollView];
    }
}
-(void)loadRightFinish{
    self.loadRightView.status = Load_LoadingDone;
    [NSTimer scheduledTimerWithTimeInterval:self.loadRightView.recoverDelay target:self selector:@selector(animationToNormalTimer:) userInfo:@{TIMER_DURATION : @(self.loadRightView.recoverDuration)} repeats:NO];
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
    
    if ((y < 0) && self.loadTopView && !self.loadTopView.isLoadComplete) {
//top
        y = MAX(y, -CGRectGetHeight(self.loadTopView.frame));
        self.loadTopView.offset = -y;
        UIEdgeInsets inset = UIEdgeInsetsMake(-y, 0, 0, 0);
        if (self.loadTopView.canAutoLoad) {
            [self loadTop];
        }else{
            if (!self.loadTopView.isLoading) {
                if (inset.top == CGRectGetHeight(self.loadTopView.frame)) {
                    if (self.loadShouldPause) {
                        self.loadTopView.status = Load_ShouldLoad;
                        inset.top = 0;
                    }else{
                        if (self.loadTopView.status != Load_LoadingDone) {
                            self.loadTopView.status = Load_ShouldLoad;
                            if (!self.scrollView.isTracking) {
                                [self loadTop];
                            }else{
                                inset.top = 0;
                            }
                        }
                    }
                }else{
                    self.loadTopView.status = Load_Pulling;
                    inset.top = 0;
                }
            }
        }
        if (inset.top != self.scrollView.contentInset.top) {
            [UIView animateWithDuration:0.1 animations:^{
                self.scrollView.contentInset = inset;
            }];
        }
    }else if ((y+CGRectGetHeight(self.scrollView.frame) > self.scrollView.contentSize.height) && self.loadBottomView && !self.loadBottomView.isLoadComplete) {
//bottom
        y = y + CGRectGetHeight(self.scrollView.frame) - self.scrollView.contentSize.height;
        y = MIN(y, CGRectGetHeight(self.loadBottomView.frame));
        self.loadBottomView.offset = y;
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, y, 0);
        if (self.loadBottomView.canAutoLoad) {
            [self loadBottom];
        }else{
            if (!self.loadBottomView.isLoading) {
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
    
    if ((x < 0) && self.loadLeftView && !self.loadLeftView.isLoadComplete) {
//left
        x = MAX(x, -CGRectGetWidth(self.loadLeftView.frame));
        self.loadLeftView.offset = -x;
        UIEdgeInsets inset = UIEdgeInsetsMake(0, -x, 0, 0);
        if (self.loadLeftView.canAutoLoad) {
            [self loadLeft];
        }else{
            if (!self.loadLeftView.isLoading) {
                if (inset.left == CGRectGetWidth(self.loadLeftView.frame)) {
                    self.loadLeftView.status = Load_ShouldLoad;
                }else{
                    self.loadLeftView.status = Load_Pulling;
                }
                inset.left = 0;
            }
        }
        if (inset.left != self.scrollView.contentInset.left) {
            [UIView animateWithDuration:0.1 animations:^{//防止突变 
                self.scrollView.contentInset = inset;
            }];
        }
    }else if ((x+CGRectGetWidth(self.scrollView.frame) > self.scrollView.contentSize.width) && self.loadRightView && !self.loadRightView.isLoadComplete) {
//right
        x = x + CGRectGetWidth(self.scrollView.frame) - self.scrollView.contentSize.width;
        x = MIN(x, CGRectGetWidth(self.loadRightView.frame));
        self.loadRightView.offset = x;
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, x);
        if (self.loadRightView.canAutoLoad) {
            [self loadRight];
        }else{
            if (!self.loadRightView.isLoading) {
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
            !self.loadTopView.isLoadComplete &&
            !self.loadTopView.canAutoLoad &&
            (y <= -CGRectGetHeight(self.loadTopView.frame))) {
            //top
            [self loadTop];
        }else if (self.loadBottomView &&
                  !self.loadBottomView.isLoadComplete &&
                  !self.loadBottomView.canAutoLoad &&
                  (y + CGRectGetHeight(self.scrollView.frame)) >= (CGRectGetHeight(self.loadBottomView.frame) + self.scrollView.contentSize.height)) {
            //bottom
            [self loadBottom];
        }
    }
    
    CGFloat x = self.scrollView.contentOffset.x;
    if ([self canLoadWithCurrentVelocityX]) {
        if (self.loadLeftView &&
            !self.loadLeftView.isLoadComplete &&
            !self.loadLeftView.canAutoLoad &&
            (x <= -CGRectGetWidth(self.loadLeftView.frame))) {
            //left
            [self loadLeft];
        }else if (self.loadRightView &&
                  !self.loadRightView.isLoadComplete &&
                  !self.loadRightView.canAutoLoad &&
                  (x + CGRectGetWidth(self.scrollView.frame)) >= (CGRectGetWidth(self.loadRightView.frame) + self.scrollView.contentSize.width)) {
            //right
            [self loadRight];
        }
    }

}

-(BOOL)canLoadWithCurrentVelocityY{
    if (self.loadShouldPause) {
        CGFloat velocityY = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView].y;
        return velocityY < 1000 && velocityY > -1000;
    }
    return YES;
}

-(BOOL)canLoadWithCurrentVelocityX{
    if (self.loadShouldPause) {
        CGFloat velocityX = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView].x;
        return velocityX < 1000 && velocityX > -1000;
    }
    return YES;
}

#pragma mark - animation
-(void)animationToNormalWithDuration:(double)duration{
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)animationToNormalTimer:(NSTimer *)timer{
    [self animationToNormalWithDuration:[timer.userInfo[TIMER_DURATION] doubleValue]];
}

@end
