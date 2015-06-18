//
//  LoadMoreView.m
//  RefreshView
//
//  Created by ileo on 15/6/17.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "LoadMoreView.h"

@interface LoadMoreView()

@end

@implementation LoadMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

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
    self.tipsL.text = self.tipsLoading;
    self.waitView.hidden = NO;
    self.waitView.center = CGPointMake(self.tipsLoading?70:CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}
-(void)showPullingView{
    self.tipsL.text = self.tipsPulling;
    self.waitView.hidden = YES;
}
-(void)showShouldLoadView{
    self.tipsL.text = self.tipsShouldLoad;
    self.waitView.hidden = YES;
}
-(void)showLoadingDoneView{
    self.tipsL.text = self.tipsLoadingDone;
    self.waitView.hidden = YES;
}

#pragma mark - 
-(UIActivityIndicatorView *)waitView{
    if (!_waitView) {
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.waitView];
        [self.waitView startAnimating];
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

@end
