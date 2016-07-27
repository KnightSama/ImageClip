//
//  ImageClipViewController.h
//  ComicPark
//
//  Created by KnightSama on 16/7/13.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import <UIKit/UIKit.h>

//裁剪结果回调
typedef void(^ResultBlock)(BOOL isCancel,UIImage *image);

@interface ImageClipViewController : UIViewController

/**
 *  @brief 要裁剪的图片
 */
@property(nonatomic,strong) UIImage *clipImage;

/**
 *  @brief 目标大小
 */
@property(nonatomic,assign) CGSize targetSize;

/**
 *  @brief 设置裁剪回调
 */
- (void)setClipResult:(ResultBlock)clipBlock;

@end
