//
//  LRLHandler.h
//  RefreshView
//
//  Created by leo on 2017/10/14.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadController.h"

@interface LRLHandler : NSObject

-(instancetype)initWithLoadController:(LoadController *)loadController;

@property (nonatomic, readonly) LoadController *loadController;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) LoadView *loadTopView;
@property (nonatomic, readonly) LoadView *loadBottomView;
@property (nonatomic, readonly) LoadView *loadLeftView;
@property (nonatomic, readonly) LoadView *loadRightView;
@property (nonatomic, readonly) UIEdgeInsets normalContentInset;//正常状态的contentInset

@end
