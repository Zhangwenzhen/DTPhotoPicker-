//
//  DTPhotoAblumCell.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoAblumCell.h"
#import "DTPhotoManager.h"


@implementation DTPhotoAblumCell



//重写cell的初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //self.selectionStyle = UITableViewCellEditingStyleNone; //设置列表点击没有灰亮
        
        self.ablumCover = [[UIImageView alloc] init];
        [self.contentView addSubview:self.ablumCover];
        [self addLayoutConstraintForAblumCover];
        

        self.ablumName = [[UILabel alloc] init];
        self.ablumName.font = [UIFont systemFontOfSize:15.0];
        self.ablumName.textColor = [UIColor blackColor];
        self.ablumName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.ablumName];
        [self addLayoutConstraintForAblumName];
        
        self.ablumCount = [[UILabel alloc] init];
        self.ablumCount.text = @"(24)";
        self.ablumCount.font = [UIFont systemFontOfSize:13.0];
        self.ablumCount.textColor = [UIColor blackColor];
        self.ablumCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.ablumCount];
        [self addLayoutConstraintForAblumCount];
        
    }
    return self;
}




- (void)setInfo:(DTAblumInfo *)info
{
    _info = info;
    
    [[DTPhotoManager manager] fetchImageInAsset:info.coverAsset
                                           size:CGSizeMake(120, 120)
                                       isResize:YES
                                  completeBlock:^(UIImage *image, NSDictionary *info)
    {
        self.ablumCover.image = image;
    }];
    
    NSDictionary *dict = @{@"All Photos":@"所有照片",
                           @"Recently Added":@"最近添加",
                           @"Camera Roll":@"相机胶卷",
                           @"Videos":@"视频",
                           @"Favorites":@"最爱",
                           @"Screenshots":@"屏幕快照",
                           @"Recently Deleted":@"最近删除",
                           };
    self.ablumName.text = dict[info.ablumName];
    
    self.ablumCount.text = [NSString stringWithFormat:@"( %ld )",info.count];
}







//添加约束
- (void)addLayoutConstraintForAblumCount
{
    self.ablumCount.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.ablumCount
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.ablumName
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.ablumCount
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:50];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.ablumCount
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:30];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.ablumCount
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.contentView addConstraints:@[c1,c2,c3,c4]];
}

//添加约束
- (void)addLayoutConstraintForAblumName
{
    self.ablumName.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.ablumName
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.ablumCover
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.ablumName
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:70];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.ablumName
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:30];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.ablumName
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.contentView addConstraints:@[c1,c2,c3,c4]];
}

//添加约束
- (void)addLayoutConstraintForAblumCover
{
    self.ablumCover.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.ablumCover
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.ablumCover
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:60];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.ablumCover
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:60];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.ablumCover
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.contentView addConstraints:@[c1,c2,c3,c4]];
}






- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
