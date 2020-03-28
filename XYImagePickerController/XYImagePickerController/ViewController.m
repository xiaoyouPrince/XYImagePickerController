//
//  ViewController.m
//  XYImagePickerController
//
//  Created by 渠晓友 on 2020/3/27.
//  Copyright © 2020 渠晓友. All rights reserved.
//

/**
 
 相机、相册 涉及用户隐私，所以在使用之前必须在 info.plist 中添加相对应的key
 
 相机: NSCameraUsageDescription
 
 
 
 */

#import "ViewController.h"
#import "XYImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    id obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController *fromVC = self;
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [XYImagePickerController presentImagePickerFromVC:fromVC sourceType:sourceType result:^(UIImage * _Nonnull image, NSString * _Nonnull errorMsg) {
        
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
            return;
        }
        
        // 图片放到第一个image
        UIImageView *icon = [UIImageView new];
        icon.image = image;
        [self.view addSubview:icon];
        icon.frame = CGRectMake(100, 100, 100, 100);
        
    }];
}


@end
