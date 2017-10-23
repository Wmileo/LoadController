//
//  UIScrollView+Load.h
//  RefreshView
//
//  Created by ileo on 16/3/22.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadController.h"

@interface UIScrollView (Load)

@property (nonatomic, strong) LoadController *loadController;

@property (nonatomic, weak) id<LoadControllerDelegate> loadDelegate;

@property (nonatomic, strong) LoadView *loadTopView;
@property (nonatomic, strong) LoadView *loadBottomView;
@property (nonatomic, strong) LoadView *loadLeftView;
@property (nonatomic, strong) LoadView *loadRightView;

@end
