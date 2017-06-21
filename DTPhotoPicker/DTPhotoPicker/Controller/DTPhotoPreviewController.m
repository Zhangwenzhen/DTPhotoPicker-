//
//  DTPhotoPreviewController.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/20.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoPreviewController.h"
#import "DTPhotoCenter.h"
#import "DTPhotoManager.h"

#import "DTPhotoBrowserCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface DTPhotoPreviewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *rightBarButton;

@property (nonatomic, strong) UIView *bottomView; //底部视图
@property (nonatomic, strong) UIButton *isOriginalBtn; //原图按钮
@property (nonatomic, strong) UIButton *completionBtn; //完成按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) DTPhotoPreviewControllerBlock returnBlock;

@end


@implementation DTPhotoPreviewController

static NSString * const reuseIdentifier = @"Cell";

//懒加载
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout)
    {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0.0;
        _layout.minimumInteritemSpacing = 0.0;
        _layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
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
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
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
//懒加载
- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_rightBarButton setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Photo_circle"] forState:UIControlStateNormal];
        [_rightBarButton setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Photo_unselected"] forState:UIControlStateSelected];
        [_rightBarButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)returnBlock:(DTPhotoPreviewControllerBlock)block
{
    self.returnBlock = block;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.returnBlock(NO,self.isOriginalBtn.selected);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    CGFloat x = self.currentImageIndex*self.view.frame.size.width;
    self.collectionView.contentOffset = CGPointMake(x, 0);
}


- (void)setupUI
{
    //设置导航右侧点击按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    //添加底部视图
    [self.view addSubview:self.bottomView];
    [self addLayoutConstraintForBottomView];
    
    //为底部视图添加“原图按钮”
    [self.bottomView addSubview:self.isOriginalBtn];
    self.isOriginalBtn.selected = self.isOriginalPhoto;
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
    self.layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-64-40-2);
    
    self.collectionView.collectionViewLayout = self.layout;
    [self.collectionView registerClass:[DTPhotoBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self addLayoutConstraintForCollectionView];
    
    //刷新标题
    [self refreshTitle];
    
    //刷新底部视图
    [self refreshBottomView];
    
}


//导航右侧按钮与底部视图 “原图” 和 “完成” 按钮的点击事件
- (void)buttonClickAction:(UIButton *)sender
{
    if ([sender isEqual:self.rightBarButton])
    {
        sender.selected = !sender.selected;
        if (sender.selected == YES)
        {
            if ([[DTPhotoCenter shareCenter] isReachMaxSelectedCount])
            {
                sender.selected = NO;
                return;
            }
            [self startSelectedAnimation:self.rightBarButton];
            [[DTPhotoCenter shareCenter].selectedPhotos addObject:self.dataSource[self.currentImageIndex]];
        }
        else
        {
            [[DTPhotoCenter shareCenter].selectedPhotos removeObject:self.dataSource[self.currentImageIndex]];
        }
        
        [self refreshBottomView];
    }
    if ([sender isEqual:self.completionBtn])
    {
        [[DTPhotoCenter shareCenter] endPick];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    if ([sender isEqual:self.isOriginalBtn])
    {
        sender.selected = !sender.selected;
        [DTPhotoCenter shareCenter].isOriginal = sender.selected;
    }
}


//刷新标题
- (void)refreshTitle
{
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentImageIndex+1,self.dataSource.count];
    
    self.rightBarButton.selected = [[DTPhotoCenter shareCenter].selectedPhotos containsObject:self.dataSource[self.currentImageIndex]];
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
         cell.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
         cell.bgImageView.userInteractionEnabled = YES;
     }];
    
    cell.selectButton.hidden = YES;

    
    return cell;
}

#pragma mark ----------------------- <UIScrollViewDelegate> -----------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    double i = currentOffset/self.view.frame.size.width;
    self.currentImageIndex = round(i);

    [self refreshTitle];
}


- (void)setIsOriginalPhoto:(BOOL)isOriginalPhoto
{
    _isOriginalPhoto = isOriginalPhoto;
    
    [DTPhotoCenter shareCenter].isOriginal = isOriginalPhoto;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
