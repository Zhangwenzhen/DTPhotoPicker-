//
//  DTPhotoManager.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAblumInfo.h"

@interface DTPhotoManager : NSObject

+ (instancetype)manager;

/*
 * 获取所有相册
 */
- (NSArray<DTAblumInfo *> *)getAllAblums;

/*
 * 获取所有相册图片资源
 */
- (NSArray<PHAsset *> *)fetchAllAssets;

/*
 * 获取指定相册图片资源
 */
- (NSArray<PHAsset *> *)fetchAssetsInCollection:(PHAssetCollection *)collection asending:(BOOL)asending;

/*
 * 获取资源对应的图片
 */
- (void)fetchImageInAsset:(PHAsset *)asset size:(CGSize)size isResize:(BOOL)isResize completeBlock:(void(^)(UIImage * image, NSDictionary * info))completeBlock;

/*
 * 获取资源对应的原图大小
 */
- (void)getImageDataLength:(PHAsset *)asset completeBlock:(void(^)(CGFloat length))completeBlock;

/*
 * 获取资源数组对应的图片数组
 */
- (void)fetchImagesWithAssetsArray:(NSMutableArray<PHAsset *> *)assetsArray isOriginal:(BOOL)isOriginal completeBlock:(void(^)(NSArray * images))completeBlock;

@end
