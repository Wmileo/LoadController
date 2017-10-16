//
//  LRLConditionHandler.h
//  RefreshView
//
//  Created by leo on 2017/10/14.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRLHandler.h"


typedef NS_ENUM(NSInteger, LRLDirection) {
    LRLDirection_Horizontal,
    LRLDirection_Vertical
};


@interface LRLConditionHandler : LRLHandler


#pragma mark - 是否可触发滑动操作
-(BOOL)canHandleScrollTop;
-(BOOL)canHandleScrollBottom;
-(BOOL)canHandleScrollLeft;
-(BOOL)canHandleScrollRight;


#pragma mark - 手指结束滑动后是否满足加载条件
-(BOOL)canLoadTopWhenEndDrag;
-(BOOL)canLoadBottomWhenEndDrag;
-(BOOL)canLoadLeftWhenEndDrag;
-(BOOL)canLoadRightWhenEndDrag;

@end
