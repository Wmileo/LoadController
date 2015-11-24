//
//  LoadMoreView.m
//  RefreshView
//
//  Created by ileo on 15/6/17.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "LoadMoreView.h"

@interface LoadMoreView()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LoadMoreView

-(void)setStatus:(Load_Status)status{
    if (_status == status) {
        return;
    }
    _status = status;
    switch (status) {
        case Load_Loading:
            [self showLoadingView];
            break;
        case Load_LoadingDone:
            [self showLoadingDoneView];
            break;
        case Load_Pulling:
            [self showPullingView];
            break;
        case Load_ShouldLoad:
            [self showShouldLoadView];
            break;
        default:
            break;
    }
}

-(void)showLoadingView{
    if (self.autoHideTips) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.tipsL.hidden = NO;
    }
    self.tipsL.text = self.tipsLoading;
    self.waitView.center = CGPointMake(self.tipsLoading?70:CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}
-(void)showPullingView{
    if (self.autoHideTips) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.tipsL.hidden = NO;
    }
    self.tipsL.text = self.tipsPulling;
    [self.waitView removeFromSuperview];
    self.waitView = nil;
}
-(void)showShouldLoadView{
    if (self.autoHideTips) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.tipsL.hidden = NO;
    }
    self.tipsL.text = self.tipsShouldLoad;
    [self.waitView removeFromSuperview];
    self.waitView = nil;
}
-(void)showLoadingDoneView{
    if (self.autoHideTips) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideTips) userInfo:nil repeats:NO];
    }
    self.tipsL.text = self.tipsLoadingDone;
    [self.waitView removeFromSuperview];
    self.waitView = nil;
}

#pragma mark - 
-(UIActivityIndicatorView *)waitView{
    if (!_waitView) {
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_waitView];
        [_waitView startAnimating];
    }
    return _waitView;
}

-(UILabel *)tipsL{
    if (!_tipsL) {
        _tipsL = [[UILabel alloc] initWithFrame:self.bounds];
        _tipsL.textAlignment = NSTextAlignmentCenter;
        _tipsL.font = [UIFont systemFontOfSize:14];
        _tipsL.textColor = [UIColor lightGrayColor];
        [self addSubview:self.tipsL];
    }
    return _tipsL;
}

-(void)hideTips{
    self.tipsL.hidden = YES;
}

@end
