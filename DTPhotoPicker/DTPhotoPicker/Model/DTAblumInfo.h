//
//  DTAblumInfo.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface DTAblumInfo : NSObject

@property (nonatomic, copy) NSString *ablumName; //相册名字

@property (nonatomic, assign) NSInteger count; //总照片数

@property (nonatomic, strong) PHAssetCollection *assetCollection; //相册

@property (nonatomic, strong) PHAsset *coverAsset; //封面

+ (instancetype)infoFromResult:(PHFetchResult *)result collection:(PHAssetCollection *)collection;

@end
