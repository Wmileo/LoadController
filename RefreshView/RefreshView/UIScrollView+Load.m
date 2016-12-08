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

-(void)setLoadDelegate:(id<LoadControllerDelegate>)loadDelegate{
    self.loadController.delegate = loadDelegate;
}

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

-(void)setLoadTopView:(LoadView *)loadView{
    self.loadController.loadTopView = loadView;
}

-(void)setLoadBottomView:(LoadView *)loadView{
    self.loadController.loadBottomView = loadView;
}

-(void)setLoadLeftView:(LoadView *)loadView{
    self.loadController.loadLeftView = loadView;
}

-(void)setLoadRightView:(LoadView *)loadView{
    self.loadController.loadRightView = loadView;
}

@end
