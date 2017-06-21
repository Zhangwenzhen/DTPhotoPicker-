//
//  DTPhotoBrowserController.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "DTPhotoBaseController.h"
@interface DTPhotoBrowserController : DTPhotoBaseController

@property (nonatomic, copy) NSString *collectionTitle;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
