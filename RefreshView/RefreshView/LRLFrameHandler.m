//
//  LRLFrameHandler.m
//  RefreshView
//
//  Created by leo on 2017/10/14.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import "LRLFrameHandler.h"

@implementation LRLFrameHandler

-(void)dealloc{
    
}

-(void)clearScrollView:(UIScrollView *)scrollView{
    [scrollView removeObserver:self forKeyPath:@"contentSize"];
}

-(instancetype)initWithLoadController:(LoadController *)loadController{
    self = [super initWithLoadController:loadController];
    if (self) {
        [self.scrollView addObserver:self
                          forKeyPath:@"contentSize"
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                             context:NULL];
    }
    return self;
}

#pragma mark - kvc
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.scrollView) {
        if ([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
            return;
        }
        if ([keyPath isEqualToString:@"contentSize"]) {
            if (self.loadBottomView) {
                self.loadBottomView.frame = [self createLoadBottomViewFrame];
            }
            if (self.loadRightView) {
                self.loadRightView.frame = [self createLoadRightViewFrame];
            }
        }
    }
}

#pragma mark - frame

-(CGRect)createLoadTopViewFrame{
    CGRect rect = self.loadTopView.frame;
    rect.origin.y = - rect.size.height;
    return rect;
}

-(CGRect)createLoadBottomViewFrame{
    CGRect rect = self.loadBottomView.frame;
    CGFloat contentHeight = self.scrollView.contentSize.height;
    rect.origin.y = contentHeight;
    return rect;
}

-(CGRect)createLoadLeftViewFrame{
    CGRect rect = self.loadLeftView.frame;
    rect.origin.x = - rect.size.width;
    return rect;
}

-(CGRect)createLoadRightViewFrame{
    CGRect rect = self.loadRightView.frame;
    CGFloat contentWidth = self.scrollView.contentSize.width;
    rect.origin.x = contentWidth;
    return rect;
}

@end
