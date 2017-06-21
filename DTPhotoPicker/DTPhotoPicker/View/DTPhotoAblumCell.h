//
//  DTPhotoAblumCell.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAblumInfo.h"

@interface DTPhotoAblumCell : UITableViewCell

@property (nonatomic, strong) UIImageView *ablumCover;
@property (nonatomic, strong) UILabel *ablumName;
@property (nonatomic, strong) UILabel *ablumCount;

@property (nonatomic, strong) DTAblumInfo *info;

@end
