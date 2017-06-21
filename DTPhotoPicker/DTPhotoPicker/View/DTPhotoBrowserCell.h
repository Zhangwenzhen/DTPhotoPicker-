//
//  DTPhotoBrowserCell.h
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, copy) void(^selectedBlock)(BOOL isSelected);



@end
