# XYImagePickerController
 一个基于 `UIImagePickerController` 的简易图片选择器。主要功能即对于系统 `UIImagePickerController` 进行了二次封装，极大简化使用，可一行代码开启选择图库/相机选图的功能。
 
 
## 优势
 
 - 内部封装了相机权限相关功能，使用无需关心权限处理
 - 集成代码高度内聚，降低耦合，可随地一行代码导入，无侵入性，不会干扰业务逻辑
 - 对外接口简单，参数明了，极大简化使用逻辑

## 适用范围
 
 适用于只需要简单调用系统相机、图库来选择图片的场景
 
 支持版本: iOS 10+
 
## 使用注意

此程序必须在 `Info.plist` 文件中提供 `Privacy - Camera Usage Description` 字段来告诉用户使用相机的原因。
 
 
## 导入代码示例
 
```
// 1. 导入头文件
#import "XYImagePickerController.h"

// 2. 一行代码添加 XYImagePickerController 选择图片
[XYImagePickerController presentImagePickerFromVC:fromVC sourceType:sourceType result:^(UIImage * _Nonnull image, NSString * _Nonnull errorMsg) {
    
    if (errorMsg) { // 处理错误信息
        NSLog(@"%@",errorMsg);
        return;
    }
    
    // 使用图片
    self.imageView.image = image;
}];
```

## 安装方式

- cocoapods
- 手动

## 协议

MIT

