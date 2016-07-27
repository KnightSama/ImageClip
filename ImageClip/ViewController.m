//
//  ViewController.m
//  ImageClip
//
//  Created by KnightSama on 16/7/27.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "ViewController.h"
#import "ImageClipViewController.h"
#import "UIView+CoreFrame.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//背景图片视图
@property(nonatomic, strong) UIImageView *backImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 20)];
    titleLabel.text = @"点击选择图片裁剪";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.backImageView.image = [UIImage imageNamed:@"Head_000.png"];
    self.backImageView.clipsToBounds = YES;
    [self.backImageView setCenter:CGPointMake(self.view.width/2.0, self.view.height/2.0)];
    self.backImageView.layer.cornerRadius = self.backImageView.height/2.0;
    self.backImageView.layer.borderWidth = 1.0;
    self.backImageView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.backImageView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self jumpToPhotoAlbum];
}

/**
 *  @brief 弹出裁剪视图
 */
- (void)jumpToClipController:(UIImage *)image completion:(void (^ __nullable)(void))completion{
    ImageClipViewController *imageClip = [[ImageClipViewController alloc] init];
    [imageClip setClipResult:^(BOOL isCancel, UIImage *image) {
        if (image) {
            self.backImageView.image = image;
        }
    }];
    imageClip.clipImage = image;
    imageClip.targetSize = CGSizeMake(200, 200);
    [self presentViewController:imageClip animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}

/**
 *  @brief  从相册取得一张图片
 */
- (void)jumpToPhotoAlbum{
    UIImagePickerController *imagePick=[[UIImagePickerController alloc] init];
    imagePick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePick.delegate = self;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window.rootViewController presentViewController:imagePick animated:YES completion:nil];
}

/**
 *  @brief 从相册取得图片的代理
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self jumpToClipController:img completion:^{
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
