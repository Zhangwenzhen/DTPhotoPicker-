//
//  DTPhotoBrowserCell.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoBrowserCell.h"

@interface DTPhotoBrowserCell ()

@end

@implementation DTPhotoBrowserCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.selectButton = [[UIButton alloc] init];
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Photo_unselected"] forState:UIControlStateNormal];
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Photo_selected"] forState:UIControlStateSelected];
        [self.selectButton addTarget:self action:@selector(selectButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectButton];
        [self addLayoutConstraintForSelectButton];
        
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.backgroundColor = [UIColor blackColor];
        self.backgroundView = self.bgImageView;
    }
    return self;
}

//添加约束
- (void)addLayoutConstraintForSelectButton
{
    self.selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.selectButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-5];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.selectButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:5];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.selectButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:25];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.selectButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:25];
    
    
    
    [self.contentView addConstraints:@[c1,c2,c3,c4]];
}

//按钮点击事件
- (void)selectButtonClickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.selectedBlock)
    {
        self.selectedBlock(sender.selected);
    }
}


@end
