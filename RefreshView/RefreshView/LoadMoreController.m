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

-(instancetype)initWithScrollView:(UIScrollView *)scrollView{

    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        self.isLoading = NO;
        self.canAutoLoadTop = YES;
        self.canAutoLoadBottom = YES;
    }
    return self;
    
}

-(void)setLoadTopView:(UIView *)loadTopView{

    if (_loadTopView && [self.scrollView.subviews containsObject:_loadTopView]) {
        [_loadTopView removeFromSuperview];
    }
    _loadTopView = loadTopView;
    CGRect rect = _loadTopView.frame;
    rect.origin.y = -rect.size.height;
    _loadTopView.frame = rect;
    [self.scrollView addSubview:_loadTopView];

}

-(void)setLoadBottomView:(UIView *)loadBottomView{

    if (_loadBottomView && [self.scrollView.subviews containsObject:_loadBottomView]) {
        [_loadBottomView removeFromSuperview];
    }
    _loadBottomView = loadBottomView;
    CGRect rect = _loadBottomView.frame;
    rect.origin.y = self.scrollView.contentSize.height;
    _loadBottomView.frame = rect;
    [self.scrollView addSubview:_loadBottomView];
    
}

-(void)repositionLoadBottomView{
    CGRect rect = self.loadBottomView.frame;
    rect.origin.y = self.scrollView.contentSize.height;
    self.loadBottomView.frame = rect;
}

-(void)showLoadTop{
    if (self.loadTopView) {
        self.isLoading = YES;
        [self.scrollView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.loadTopView.frame)) animated:YES];
    }
}

-(void)disappearLoadTop{
    if (self.scrollView.contentInset.top != 0) {
        __weak __typeof(self) wself = self;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            wself.scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            wself.isLoading = NO;
        }];
    }
}

-(void)disappearLoadBottom{
    [self loadBottomFinish];
}

#pragma mark - 
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y < 0 && self.loadTopView) {//top
        y = MAX(y, -CGRectGetHeight(self.loadTopView.frame));
        UIEdgeInsets inset = UIEdgeInsetsMake(-y, 0, 0, 0);
        if (self.canAutoLoadTop) {
            if (!self.isLoading) {
                [self loadMoreTopAutoLoad];
            }
        }else{
            if (!self.isLoading) {
                inset.top = 0;
            }
        }
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = inset;
        }];
    }else if (y+CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height && self.loadBottomView) {//bottom
        y = y + CGRectGetHeight(scrollView.frame) - scrollView.contentSize.height;
        y = MIN(y, CGRectGetHeight(self.loadBottomView.frame));
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, y, 0);
        if (self.canAutoLoadBottom) {
            if (!self.isLoading) {
                [self loadMoreBottomAutoLoad];
            }
        }else{
            if (!self.isLoading) {
//                inset.bottom = 0;
            }
        }
        scrollView.contentInset = inset;
    }else if (scrollView.contentInset.top != 0 || scrollView.contentInset.bottom != 0){
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView{

    CGFloat y = scrollView.contentOffset.y;
    if (self.loadTopView &&
        !self.canAutoLoadTop &&
        y <= -CGRectGetHeight(self.loadTopView.frame)) {//top
        [self loadMoreTop];
        NSLog(@"start");
    }else if (self.loadBottomView &&
              !self.canAutoLoadBottom &&
              (y + CGRectGetHeight(scrollView.frame)) >= (CGRectGetHeight(self.loadBottomView.frame) + scrollView.contentSize.height)) {//bottom
        [self loadMoreBottom];
    }

}

#pragma mark - top
-(void)loadMoreTop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTopLoadFinish:)]) {
        self.isLoading = YES;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreTopLoadFinish:^(CGFloat insetHeight) {
            [wself loadTopFinishWithInsetHeight:insetHeight];
        }];
    }
}
-(void)loadMoreTopAutoLoad{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTopAutoLoadFinish:)]) {
        self.isLoading = YES;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreTopAutoLoadFinish:^(CGFloat insetHeight) {
            [wself loadTopFinishWithInsetHeight:insetHeight];
        }];
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
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.isLoading = NO;
        NSLog(@"f-0");
    }else if (top != 0) {
        __weak __typeof(self) wself = self;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            wself.scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            wself.isLoading = NO;
            NSLog(@"f - h - 0");
        }];
    }else{
        self.isLoading = NO;
    }
}

#pragma mark - bottom
-(void)loadMoreBottomAutoLoad{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreBottomAutoLoadFinish:)]) {
        self.isLoading = YES;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreBottomAutoLoadFinish:^{
            [wself loadBottomFinish];
        }];
    }
}
-(void)loadMoreBottom{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreBottomLoadFinish:)]) {
        self.isLoading = YES;
        __weak __typeof(self) wself = self;
        [self.delegate loadMoreBottomLoadFinish:^{
            [wself loadBottomFinish];
        }];
    }
}
-(void)loadBottomFinish{
    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        wself.scrollView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {
        wself.isLoading = NO;
    }];
}

@end
