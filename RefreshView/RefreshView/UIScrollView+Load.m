//
//  UIScrollView+Load.m
//  RefreshView
//
//  Created by ileo on 16/3/22.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import "UIScrollView+Load.h"
#import <objc/runtime.h>

@implementation UIScrollView (Load)

static char loadControllerKey;

-(void)setLoadController:(LoadController *)loadController{
    objc_setAssociatedObject(self, &loadControllerKey, loadController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(LoadController *)loadController{
    LoadController *load = objc_getAssociatedObject(self, &loadControllerKey);
    if (!load) {
        load = [[LoadController alloc] initWithScrollView:self];
        objc_setAssociatedObject(self, &loadControllerKey, load, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return load;
}

-(void)setLoadDelegate:(id<LoadControllerDelegate>)loadDelegate{
    self.loadController.delegate = loadDelegate;
}

-(id<LoadControllerDelegate>)loadDelegate{
    return self.loadController.delegate;
}

-(void)setLoadTopView:(LoadView *)loadTopView{
    self.loadController.loadTopView = loadTopView;
}

-(LoadView *)loadTopView{
    return self.loadController.loadTopView;
}

-(void)setLoadBottomView:(LoadView *)loadBottomView{
    self.loadController.loadBottomView = loadBottomView;
}

-(LoadView *)loadBottomView{
    return self.loadController.loadBottomView;
}

-(void)setLoadLeftView:(LoadView *)loadLeftView{
    self.loadController.loadLeftView = loadLeftView;
}

-(LoadView *)loadLeftView{
    return self.loadController.loadLeftView;
}

-(void)setLoadRightView:(LoadView *)loadRightView{
    self.loadController.loadRightView = loadRightView;
}

-(LoadView *)loadRightView{
    return self.loadController.loadRightView;
}

@end
