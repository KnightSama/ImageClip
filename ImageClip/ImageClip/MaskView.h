//
//  MaskView.h
//  ComicPark
//
//  Created by KnightSama on 16/7/15.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView

/**
 *  @brief 需要响应事件的view
 */
@property(nonatomic,strong) UIView *respondView;

/**
 *  @brief 目标大小
 */
@property(nonatomic,assign) CGSize targetSize;

@end
