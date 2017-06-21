//
//  DTAblumInfo.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTAblumInfo.h"


@implementation DTAblumInfo

+ (instancetype)infoFromResult:(PHFetchResult *)result collection:(PHAssetCollection *)collection
{
    DTAblumInfo * ablumInfo = [[DTAblumInfo alloc]init];
    ablumInfo.ablumName = collection.localizedTitle;
    ablumInfo.count = result.count;
    ablumInfo.coverAsset = result[0];
    ablumInfo.assetCollection = collection;
    return ablumInfo;
}

@end
