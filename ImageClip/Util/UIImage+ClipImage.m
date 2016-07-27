//
//  UIImage+ClipImage.m
//  ComicPark
//
//  Created by KnightSama on 16/7/14.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "UIImage+ClipImage.h"

@implementation UIImage (ClipImage)

/**
 *  @brief 由图片与矩形区域获得一张裁剪后的图片
 */
- (UIImage *)clipByRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect newRect = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    UIGraphicsBeginImageContext(newRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, newRect, imageRef);
    UIImage *clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return clipImage;
}

/**
 *  @brief 通过图片返回一张圆形图
 */
- (UIImage *)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    //1、获得原来的图片
    UIImage *oldImge= self;
    //2、要绘图，首先得创建上下文
    CGFloat imgW=oldImge.size.width+2*borderWidth;
    CGFloat imgH=oldImge.size.height+2*borderWidth;
    CGSize imgSize=CGSizeMake(imgW, imgH);
    UIGraphicsBeginImageContext(imgSize);
    //3、得到绘图上下文
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [borderColor set];//设置填充颜色
    //4、画大圆（边框）
    CGFloat radius=imgW/2.0f;//大圆的半径
    CGFloat cenX=radius;
    CGFloat cenY=radius;
    CGContextAddArc(ctx, cenX, cenY, radius, 0, 2*M_PI, 0);
    CGContextFillPath(ctx);
    //5、画小圆
    CGFloat smallRadius=radius-borderWidth;//小圆的半径
    //画了一个小圆
    CGContextAddArc(ctx, cenX, cenY, smallRadius, 0,  2*M_PI, 0);
    //裁剪
    CGContextClip(ctx);
    //6、画图
    [oldImge drawInRect:CGRectMake(borderWidth, borderWidth, oldImge.size.width, oldImge.size.height)];
    //7、得到画好的后的图片
    UIImage *newImg=UIGraphicsGetImageFromCurrentImageContext();
    //8、结束上下文
    UIGraphicsEndImageContext();
    return newImg;
}

@end
