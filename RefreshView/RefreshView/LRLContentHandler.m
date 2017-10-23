//
//  LRLContentInsetHandler.m
//  RefreshView
//
//  Created by leo on 2017/10/16.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import "LRLContentHandler.h"

@implementation LRLContentHandler

-(void)dealloc{

}

-(CGFloat)offsetTop{
    return - MAX(-CGRectGetHeight(self.loadTopView.frame), self.scrollView.contentOffset.y + self.normalContentInset.top);
}

-(CGFloat)offsetBottom{
    return MIN(CGRectGetHeight(self.loadBottomView.frame), self.scrollView.contentOffset.y + CGRectGetHeight(self.scrollView.frame) - self.scrollView.contentSize.height);
}

-(CGFloat)offsetLeft{
    return - MAX(-CGRectGetWidth(self.loadLeftView.frame), self.scrollView.contentOffset.x + self.normalContentInset.left);
}

-(CGFloat)offsetRight{
    return MIN(CGRectGetWidth(self.loadRightView.frame), self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame) - self.scrollView.contentSize.width);
}

-(UIEdgeInsets)insetWithOffsetTop{
    UIEdgeInsets inset = self.normalContentInset;
    inset.top = self.normalContentInset.top + [self offsetTop];
    return inset;
}

-(UIEdgeInsets)insetWithOffsetBottom{
    UIEdgeInsets inset = self.normalContentInset;
    inset.bottom = [self offsetBottom];
    return inset;
}

-(UIEdgeInsets)insetWithOffsetLeft{
    UIEdgeInsets inset = self.normalContentInset;
    inset.left = self.normalContentInset.left + [self offsetLeft];
    return inset;
}

-(UIEdgeInsets)insetWithOffsetRight{
    UIEdgeInsets inset = self.normalContentInset;
    inset.right = [self offsetRight];
    return inset;
}

@end
