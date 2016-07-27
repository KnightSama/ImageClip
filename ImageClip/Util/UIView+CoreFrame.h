//
//  UIView+CoreFrame.h
//  CoreSDK
//
//  Created by KnightSama on 16/6/16.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CoreFrame)

/**
 *  @brief 返回视图的 X 坐标
 */
@property(nonatomic ,assign) CGFloat left;

/**
 *  @brief 返回视图的 Y 坐标
 */
@property(nonatomic ,assign) CGFloat top;

/**
 *  @brief 返回视图的长度
 */
@property(nonatomic ,assign) CGFloat width;

/**
 *  @brief 返回视图的高度
 */
@property(nonatomic ,assign) CGFloat height;

/**
 *  @brief 返回视图的右侧位置
 */
@property(nonatomic ,assign ,readonly) CGFloat right;

/**
 *  @brief 返回视图的底部位置
 */
@property(nonatomic ,assign ,readonly) CGFloat bottom;

/**
 *  @brief 返回视图的中心坐标
 */
@property(nonatomic ,assign) CGPoint center;
@end
