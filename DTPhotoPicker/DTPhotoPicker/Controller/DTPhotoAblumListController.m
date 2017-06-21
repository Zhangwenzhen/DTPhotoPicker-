//
//  DTPhotoAblumListController.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/16.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoAblumListController.h"
#import "DTPhotoAblumCell.h"
#import "DTPhotoBrowserController.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface DTPhotoAblumListController () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UITableView * tableView;

@end

@implementation DTPhotoAblumListController

//懒加载列表视图
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,10)];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"照片"];
//    //去掉半透明
//    self.navigationController.navigationBar.translucent = NO;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI
{
    //添加表格
    [self.view addSubview:self.tableView];
    
    [self addLayoutConstraintForTableView];
    
    
    //添加导航右侧“取消”按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelBtnAction)];
    self.navigationItem.rightBarButtonItem = item;

}



- (void)addLayoutConstraintForTableView
{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0];

    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0];
    
    [self.view addConstraints:@[c1,c2,c3,c4]];
    
}


- (void)cancelBtnAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -------- <UITableViewDataSource, UITableViewDelegate> --------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetCollections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    DTPhotoAblumCell *cell = (DTPhotoAblumCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[DTPhotoAblumCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.info = self.assetCollections[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DTPhotoBrowserController *VC = [DTPhotoBrowserController new];
    DTAblumInfo *info = self.assetCollections[indexPath.row];
    VC.assetCollection = info.assetCollection;
    VC.collectionTitle = info.ablumName;;
    [self.navigationController pushViewController:VC animated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
