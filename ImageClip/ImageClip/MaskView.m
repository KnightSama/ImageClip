//
//  MaskView.m
//  ComicPark
//
//  Created by KnightSama on 16/7/15.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (self.respondView&&![view isKindOfClass:[UIButton class]]) {
        return self.respondView;
    }
    return [super hitTest:point withEvent:event];
}

@end
