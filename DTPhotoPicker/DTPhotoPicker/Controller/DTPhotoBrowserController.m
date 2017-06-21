//
//  DTPhotoBrowserController.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/19.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoBrowserController.h"
#import "DTPhotoCenter.h"
#import "DTPhotoManager.h"

#import "DTPhotoBrowserCell.h"

#import "DTPhotoPreviewController.h"


@interface DTPhotoBrowserController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIView *bottomView; //底部视图
@property (nonatomic, strong) UIButton *isOriginalBtn; //原图按钮
@property (nonatomic, strong) UIButton *completionBtn; //完成按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) BOOL isNeedClearSelectedPhotos; //是否需要清除选中的照片

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation DTPhotoBrowserController

static NSString * const reuseIdentifier = @"Cell";

//懒加载
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout)
    {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake((self.view.frame.size.width-5*5)/4, (self.view.frame.size.width-5*5)/4);
        _layout.minimumLineSpacing = 5.0;
        _layout.minimumInteritemSpacing = 5.0;
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //设置视图的滚动方式为竖直滚动
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}
//懒加载
- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:38/255.0 green:184/255.0 blue:243/255.0 alpha:1.0];
    }
    return _bottomView;
}
//懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
//懒加载
- (UIButton *)isOriginalBtn
{
    if (!_isOriginalBtn)
    {
        _isOriginalBtn = [[UIButton alloc] init];
        [_isOriginalBtn setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Photo_circle"] forState:UIControlStateNormal];
        [_isOriginalBtn setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Photo_unselected"] forState:UIControlStateSelected];
        [_isOriginalBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _isOriginalBtn;
}
//懒加载
- (UIButton *)completionBtn
{
    if (!_completionBtn)
    {
        _completionBtn = [[UIButton alloc] init];
        [_completionBtn setTitle:@"完成" forState:UIControlStateNormal];
        _completionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_completionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completionBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completionBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isNeedClearSelectedPhotos = YES;
    
    [self loadAssetData];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    //清空上次选择的图片
    if (self.isNeedClearSelectedPhotos == YES)
    {
        [[DTPhotoCenter shareCenter].selectedPhotos removeAllObjects];
    }
    
    [self refreshBottomView];
    [self.collectionView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

//加载数据
- (void)loadAssetData
{
    self.dataSource = [[DTPhotoManager manager] fetchAssetsInCollection:self.assetCollection asending:NO];
}

//加载UI
- (void)setupUI
{
    //设置标题
    NSDictionary *dict = @{@"All Photos":@"所有照片",
                           @"Recently Added":@"最近添加",
                           @"Camera Roll":@"相机胶卷",
                           @"Videos":@"视频",
                           @"Favorites":@"最爱",
                           @"Screenshots":@"屏幕快照",
                           @"Recently Deleted":@"最近删除",
                           };
    self.title = dict[self.collectionTitle];
    
    
    //添加导航右侧“取消”按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelBtnAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    //添加底部视图
    [self.view addSubview:self.bottomView];
    [self addLayoutConstraintForBottomView];
    
    //为底部视图添加“原图按钮”
    [self.bottomView addSubview:self.isOriginalBtn];
    [self addLayoutConstraintForIsOriginalBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"原图";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:label];
    [self addLayoutConstraintForLabel:label];
    
    //为底部视图添加“完成按钮”
    [self.bottomView addSubview:self.completionBtn];
    [self addLayoutConstraintForCompletionBtn];
    
    //添加图片视图
    self.collectionView.collectionViewLayout = self.layout;
    [self.collectionView registerClass:[DTPhotoBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self addLayoutConstraintForCollectionView];
    
    

}



//导航右侧“取消”点击事件
- (void)cancelBtnAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//底部视图 “原图” 和 “完成” 按钮的点击事件
- (void)buttonClickAction:(UIButton *)sender
{
    if ([sender isEqual:self.isOriginalBtn])
    {
        sender.selected = !sender.selected;
        [DTPhotoCenter shareCenter].isOriginal = sender.selected;
    }
    else
    {
        [[DTPhotoCenter shareCenter] endPick];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -------- <UICollectionViewDataSource,UICollectionViewDelegate> --------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DTPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [[DTPhotoManager manager] fetchImageInAsset:self.dataSource[indexPath.row]
                                           size:CGSizeMake(cell.frame.size.width * 2, cell.frame.size.height * 2)
                                       isResize:YES
                                  completeBlock:^(UIImage *image, NSDictionary *info)
    {
        cell.bgImageView.image = image;
        cell.bgImageView.contentMode = UIViewContentModeScaleToFill;
        cell.bgImageView.userInteractionEnabled = NO;
    }];
    
    cell.selectButton.selected = [[DTPhotoCenter shareCenter].selectedPhotos containsObject:self.dataSource[indexPath.row]];
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setSelectedBlock:^(BOOL isSelected)
    {
        if (isSelected)
        {
            if ([[DTPhotoCenter shareCenter] isReachMaxSelectedCount])
            {
                weakCell.selectButton.selected = NO;
                return;
            }
            [self startSelectedAnimation:weakCell.selectButton];
            [[DTPhotoCenter shareCenter].selectedPhotos addObject:weakSelf.dataSource[indexPath.row]];
        }
        else
        {
            [[DTPhotoCenter shareCenter].selectedPhotos removeObject:weakSelf.dataSource[indexPath.row]];
        }
        [weakSelf refreshBottomView];
    }];
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DTPhotoPreviewController *VC = [DTPhotoPreviewController new];
    
    VC.currentImageIndex = indexPath.item;
    VC.dataSource = self.dataSource;
    
    [self.navigationController pushViewController:VC animated:YES];
    
    [VC returnBlock:^(BOOL isClearPhotos, BOOL isOriginalPhoto)
    {
        if (isClearPhotos == NO)
        {
            self.isNeedClearSelectedPhotos = NO;
            self.isOriginalBtn.selected = isOriginalPhoto;
            [DTPhotoCenter shareCenter].isOriginal = isOriginalPhoto;
        }
    }];
}

//刷新底部视图
- (void)refreshBottomView
{
    if ([DTPhotoCenter shareCenter].selectedPhotos.count > 0)
    {
        self.isOriginalBtn.selected = [DTPhotoCenter shareCenter].isOriginal;
        NSString *title = [NSString stringWithFormat:@"完成(%ld)",[DTPhotoCenter shareCenter].selectedPhotos.count];
        [_completionBtn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        self.isOriginalBtn.selected = NO;
        [_completionBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮震动动画
- (void)startSelectedAnimation:(UIView *)view
{
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    ani.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.removedOnCompletion = YES;
    ani.fillMode = kCAFillModeForwards;
    ani.duration = 0.4;
    [view.layer addAnimation:ani forKey:@"transformAni"];
}








//添加约束
- (void)addLayoutConstraintForCollectionView
{
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.view addConstraints:@[c1,c2,c3,c4]];
}
//添加约束
- (void)addLayoutConstraintForBottomView
{
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:40];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.view addConstraints:@[c1,c2,c3,c4]];
    
}
//添加约束
- (void)addLayoutConstraintForCompletionBtn
{
    self.completionBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.completionBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-20];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.completionBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:80];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.completionBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.completionBtn
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.view addConstraints:@[c1,c2,c3,c4]];
}
//添加约束
- (void)addLayoutConstraintForIsOriginalBtn
{
    self.isOriginalBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.isOriginalBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.isOriginalBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.isOriginalBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.isOriginalBtn
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.view addConstraints:@[c1,c2,c3,c4]];
}
//添加约束
- (void)addLayoutConstraintForLabel:(UILabel *)label
{
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.isOriginalBtn
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:50];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:20];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.view addConstraints:@[c1,c2,c3,c4]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
