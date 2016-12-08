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

-(void)setLoadDelegate:(id<LoadControllerDelegate>)loadDelegate;

-(void)setLoadTopView:(LoadView *)loadView;
-(void)setLoadBottomView:(LoadView *)loadView;
-(void)setLoadLeftView:(LoadView *)loadView;
-(void)setLoadRightView:(LoadView *)loadView;

@end
