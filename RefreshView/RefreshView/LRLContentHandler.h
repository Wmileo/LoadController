//
//  LRLContentInsetHandler.h
//  RefreshView
//
//  Created by leo on 2017/10/16.
//  Copyright © 2017年 ileo. All rights reserved.
//

#import "LRLHandler.h"

@interface LRLContentHandler : LRLHandler

#pragma mark - 有效位移 正数
-(CGFloat)offsetTop;
-(CGFloat)offsetBottom;
-(CGFloat)offsetLeft;
-(CGFloat)offsetRight;

-(UIEdgeInsets)insetWithOffsetTop;
-(UIEdgeInsets)insetWithOffsetBottom;
-(UIEdgeInsets)insetWithOffsetLeft;
-(UIEdgeInsets)insetWithOffsetRight;

//-(void)setOffsetWithNewX:(CGFloat)x;
//-(void)setOffsetWithNewY:(CGFloat)y;

@end
