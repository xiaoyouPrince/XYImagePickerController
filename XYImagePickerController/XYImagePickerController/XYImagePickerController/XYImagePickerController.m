//
//  XYImagePickerController.m
//  XYImagePickerController
//
//  Created by 渠晓友 on 2020/3/27.
//  Copyright © 2020 渠晓友. All rights reserved.
//

#import "XYImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

static NSString *NoCameraAccessAlertTitle = @"Unable to access the Camera";
static NSString *NoCameraAccessAlertMessage = @"To turn on camera access, choose Settings > Privacy > Camera and turn on Camera access for this app.";

@interface XYImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** callBackHandler */
@property (nonatomic, copy)         void(^callBackHandler)(UIImage *image, NSString *errorMsg);
/** presetntionController */
@property (nonatomic, strong)       UIViewController * presetntionController;
/** imagePicker */
@property (nonatomic, strong)       UIImagePickerController * imagePicker;
@end
@implementation XYImagePickerController
/// 内部保持自己不被销毁,需要手动销毁置空
static XYImagePickerController *_instance;

+ (void)presentImagePickerFromVC:(UIViewController *)controller sourceType:(UIImagePickerControllerSourceType)sourceType result:(void (^)(UIImage * _Nonnull, NSString * _Nonnull))result
{
    XYImagePickerController *instance = nil;
    if (!controller) {
        controller = [[UIApplication sharedApplication].keyWindow rootViewController];
    }
    instance = [XYImagePickerController new];
    instance.callBackHandler = result;
    instance.presetntionController = controller;
    _instance = instance;
    
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = instance;
    instance.imagePicker = imagePicker;
    
    [instance presentImagePickerForSourceType:sourceType];
}

#pragma mark - private
- (void)presentImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self showImagePickerForCamera];
    }else
    {
        [self showImagePickerForPhotoPicker];
    }
}


- (void)showImagePickerForCamera{
    
    // 检测相机设备是否可用
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!cameraAvailable) {
        if (self.callBackHandler) {
            self.callBackHandler(nil, @"相机设备不可用");
        }
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NoCameraAccessAlertTitle message:NoCameraAccessAlertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 取消
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 去设置
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:^(BOOL success) {
                    // 成功进入设置
                }];
            }
        }]];
        [self.presetntionController presentViewController:alert animated:YES completion:nil];
        
        if (self.callBackHandler) {
            self.callBackHandler(nil, @"无相机访问权限");
        }
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                   // 重新推出
                    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                   // 重新推出
                    if (self.callBackHandler) {
                        self.callBackHandler(nil, @"用户拒绝相机访问权限");
                    }
                });
            }
        }];
    }else
    {
        // 直接推出
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)showImagePickerForPhotoPicker{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType{
    self.imagePicker.sourceType = sourceType;
    self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.presetntionController presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - ImagePickerDeledate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.callBackHandler) {
            self.callBackHandler(image,nil);
        }
        _instance = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.callBackHandler) {
            self.callBackHandler(nil,@"用户手动取消了选择图片");
        }
        _instance = nil;
    }];
}

- (void)dealloc
{
    NSLog(@" ----- _instance = nil;");
}

@end
