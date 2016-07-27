//
//  UIImage+ClipImage.h
//  ComicPark
//
//  Created by KnightSama on 16/7/14.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ClipImage)

/**
 *  @brief 由图片与矩形区域获得一张裁剪后的图片
 */
- (UIImage *)clipByRect:(CGRect)rect;

/**
 *  @brief 通过图片返回一张圆形图
 */
- (UIImage *)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
