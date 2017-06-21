//
//  DTPhotoPreviewController.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/20.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "DTPhotoBaseController.h"

//从相机返回的一张图片
typedef void(^DTPhotoPreviewControllerBlock)(BOOL isClearPhotos,BOOL isOriginalPhoto);

@interface DTPhotoPreviewController : DTPhotoBaseController

@property (nonatomic, assign) NSUInteger currentImageIndex; //当前图片的index
@property (nonatomic, strong) NSArray *dataSource;;  //该目录下图片的数组
@property (nonatomic, assign) BOOL isOriginalPhoto;  //是否选中“原图”



- (void)returnBlock:(DTPhotoPreviewControllerBlock)block;



@end
