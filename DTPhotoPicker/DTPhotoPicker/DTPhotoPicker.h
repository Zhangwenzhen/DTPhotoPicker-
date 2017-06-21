//
//  DTPhotoPicker.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/16.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

//从相机返回的一张图片
typedef void(^DTPhotoPickerCameraBlock)(UIImage *image);

@interface DTPhotoPicker : NSObject

/*
 *最大选择数,默认为20
 */
@property (nonatomic, assign) NSInteger selectedCount;


- (void)showInSender:(UIViewController *)sender pickedImagesFromPhotoLibrary:(void(^)(NSArray<UIImage *> * photos))handle;

- (void)showInSender:(UIViewController *)sender pickedImagesFromCamera:(DTPhotoPickerCameraBlock)handle;

@end
