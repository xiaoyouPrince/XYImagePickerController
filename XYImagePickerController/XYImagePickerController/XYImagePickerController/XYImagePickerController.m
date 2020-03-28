//
//  XYImagePickerController.m
//  XYImagePickerController
//
//  Created by 渠晓友 on 2020/3/27.
//  Copyright © 2020 渠晓友. All rights reserved.
//

#import "XYImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface XYImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** callBackHandler */
@property (nonatomic, copy)         void(^callBackHandler)(UIImage *image, NSString *errorMsg);
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
    _instance = instance;
    
    // 推出imagePicker
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = instance;
    imagePicker.sourceType = sourceType;
    [controller presentViewController:imagePicker animated:YES completion:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 权限处理
        
        
    }
    return self;
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
