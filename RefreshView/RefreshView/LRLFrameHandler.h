//
//  LRLFrameHandler.h
//  RefreshView
//
//  Created by leo on 2017/10/14.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRLHandler.h"

@interface LRLFrameHandler : LRLHandler

-(CGRect)createLoadTopViewFrame;
-(CGRect)createLoadBottomViewFrame;
-(CGRect)createLoadLeftViewFrame;
-(CGRect)createLoadRightViewFrame;

@end
