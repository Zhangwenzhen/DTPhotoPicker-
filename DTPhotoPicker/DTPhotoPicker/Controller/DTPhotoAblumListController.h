//
//  DTPhotoAblumListController.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/16.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "DTPhotoBaseController.h"

@interface DTPhotoAblumListController : DTPhotoBaseController

@property (nonatomic, strong) NSArray *assetCollections;   //相册列表

@property (nonatomic, strong) UITableView * tableView;

@end
