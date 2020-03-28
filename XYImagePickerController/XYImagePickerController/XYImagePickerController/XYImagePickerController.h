//
//  XYImagePickerController.h
//  XYImagePickerController
//
//  Created by 渠晓友 on 2020/3/27.
//  Copyright © 2020 渠晓友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYImagePickerController : NSObject

/// 推出图片选择器
/// @param controller 在哪个VC上推出
/// @param sourceType 图片来源
/// @param result 操作结果
+ (void)presentImagePickerFromVC:(nullable UIViewController *)controller
                      sourceType:(UIImagePickerControllerSourceType)sourceType
                          result:(void(^)(UIImage *image, NSString *errorMsg))result;

@end

NS_ASSUME_NONNULL_END
