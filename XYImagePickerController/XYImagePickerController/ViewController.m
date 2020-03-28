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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@end

@implementation ViewController


- (IBAction)getImageWithCamera:(id)sender {
    
    UIViewController *fromVC = self;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [XYImagePickerController presentImagePickerFromVC:fromVC sourceType:sourceType result:^(UIImage * _Nonnull image, NSString * _Nonnull errorMsg) {
        
        if (errorMsg) { // 处理错误信息
            NSLog(@"%@",errorMsg);
            self.reasonLabel.text = [@"操作失败:" stringByAppendingString:errorMsg];
            return;
        }
        
        // 使用图片
        self.imageView.image = image;
        self.reasonLabel.text = @"操作成功";
    }];
}

- (IBAction)getImageWithAlbum:(id)sender {
    
    UIViewController *fromVC = self;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    [XYImagePickerController presentImagePickerFromVC:fromVC sourceType:sourceType result:^(UIImage * _Nonnull image, NSString * _Nonnull errorMsg) {
        
        if (errorMsg) { // 处理错误信息
            NSLog(@"%@",errorMsg);
            self.reasonLabel.text = [@"操作失败:" stringByAppendingString:errorMsg];
            return;
        }
        
        // 使用图片
        self.imageView.image = image;
        self.reasonLabel.text = @"操作成功";
    }];
}



@end
