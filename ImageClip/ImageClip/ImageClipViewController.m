//
//  ImageClipViewController.m
//  ComicPark
//
//  Created by KnightSama on 16/7/13.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "ImageClipViewController.h"
#import "UIView+CoreFrame.h"
#import "UIImage+ClipImage.h"
#import "MaskView.h"

@interface ImageClipViewController ()<UIScrollViewDelegate>
//底层的ScrollView
@property(nonatomic, strong) UIScrollView *scroll;
//中间显示图片的view
@property(nonatomic, strong) UIImageView *imageView;
//上层的遮罩视图
@property(nonatomic, strong) MaskView *maskView;
// 裁剪回调
@property(nonatomic,copy) ResultBlock clipBlock;
//图片展示视图
@property(nonatomic, strong) UIView *showView;
@property(nonatomic, strong) UIImageView *showImageView;
@end

@implementation ImageClipViewController

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    //创建底层的scroll
    [self createScrollView];
    //创建遮罩视图
    [self createMaskView];
    //创建按钮
    [self createSelectBtn];
}

/**
 *  @brief 创建底层的scroll
 */
- (void)createScrollView{
    self.scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scroll.delegate = self;
    self.scroll.clipsToBounds = NO;
    self.scroll.bounces = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.minimumZoomScale = 1.0;
    self.scroll.maximumZoomScale = 3.0;
    //创建显示图片的view
    [self createImageView];
    //设置Scroll的ContentSize
    [self.scroll setFrame:CGRectMake((self.view.width-self.targetSize.width)/2.0, (self.view.height-self.targetSize.height)/2.0, self.targetSize.width, self.targetSize.height)];
    self.scroll.contentSize = self.imageView.frame.size;
    self.scroll.contentOffset = CGPointMake((self.scroll.contentSize.width-self.scroll.width)/2.0, (self.scroll.contentSize.height-self.scroll.height)/2.0);
    [self.view addSubview:self.scroll];
}

/**
 *  @brief 添加展示图片的视图
 */
- (void)createImageView{
    self.imageView = [[UIImageView alloc] initWithImage:self.clipImage];
    [self.imageView setFrame:CGRectMake(0, 0, self.imageView.width * self.targetSize.height/self.imageView.height, self.targetSize.height)];
    if (self.imageView.width<self.targetSize.width) {
        [self.imageView setFrame:CGRectMake(0, 0, self.targetSize.width, self.imageView.height * self.targetSize.width/self.imageView.width)];
    }
    [self.scroll addSubview:self.imageView];
}

/**
 *  @brief 添加一个遮罩
 */
- (void)createMaskView{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [path appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.view.width-self.targetSize.width)/2.0, (self.view.height-self.targetSize.height)/2.0, self.targetSize.width, self.targetSize.height)] bezierPathByReversingPath]];
    layer.path = path.CGPath;
    self.maskView = [[MaskView alloc] initWithFrame:self.view.bounds];
    self.maskView.respondView = self.scroll;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    self.maskView.layer.mask = layer;
    [self.view addSubview:self.maskView];
}

/**
 *  @brief 创建选择按钮
 */
- (void)createSelectBtn{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-64, self.view.width, 64)];
    view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
    [self.maskView addSubview:view];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (view.height-44)/2.0, (view.width-30)/2.0, 44)];
    cancelBtn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    cancelBtn.tag = 101;
    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right+10, (view.height-44)/2.0, (view.width-30)/2.0, 44)];
    confirmBtn.tag = 102;
    [confirmBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    [confirmBtn setTitle:@"裁 剪" forState:UIControlStateNormal];
    [view addSubview:confirmBtn];
}

/**
 *  @brief 设置裁剪回调
 */
- (void)setClipResult:(ResultBlock)clipBlock{
    self.clipBlock = clipBlock;
}

#pragma mark - scroll delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.scroll.contentSize = self.imageView.frame.size;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate)
    {
        //取消惯性滑动
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        });
    }
}

#pragma mark - 裁剪图片

- (void)showClipImage{
    self.showView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.showView.backgroundColor = [UIColor blackColor];
    self.showImageView = [[UIImageView alloc] initWithImage:[self imageAfterClip]];
    [self.showImageView setFrame:CGRectMake(0, 0, self.targetSize.width, self.targetSize.height)];
    self.showImageView.center = self.showView.center;
    [self.showView addSubview:self.showImageView];
    [self.view addSubview:self.showView];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.showView.height-54, (self.showView.width-30)/2.0, 44)];
    cancelBtn.backgroundColor = [UIColor grayColor];
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    cancelBtn.tag = 103;
    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:cancelBtn];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right+10, self.showView.height-54, (self.showView.width-30)/2.0, 44)];
    confirmBtn.backgroundColor = [UIColor grayColor];
    confirmBtn.tag = 104;
    [confirmBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [self.showView addSubview:confirmBtn];
}

/**
 *  @brief 按要求裁剪图片
 */
- (UIImage *)imageAfterClip{
    //当前图片大小
    CGSize imageSize = self.imageView.frame.size;
    //当前被选中的区域
    CGRect clipRect = CGRectMake(self.scroll.contentOffset.x, self.scroll.contentOffset.y, self.targetSize.width, self.targetSize.height);
    //实际图片的倍数
    CGFloat scale = self.clipImage.size.width/imageSize.width;
    //实际图片裁剪位置
    clipRect = CGRectMake(clipRect.origin.x*scale, clipRect.origin.y*scale, clipRect.size.width*scale, clipRect.size.height*scale);
    //裁剪后图片
    UIImage *image = [self.clipImage clipByRect:clipRect];
    return image;
}

/**
 *  @brief 按钮的点击方法
 */
- (void)buttonClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:{
            if (self.clipBlock) {
                self.clipBlock(YES,nil);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 102:{
            [self showClipImage];
            break;
        }
        case 103:{
            [self.showView removeFromSuperview];
            break;
        }
        case 104:{
            if (self.clipBlock) {
                self.clipBlock(NO,self.showImageView.image);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
