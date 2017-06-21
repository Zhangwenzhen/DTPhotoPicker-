//
//  DTPhotoBaseController.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/16.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoBaseController.h"
#import <Photos/Photos.h>

@interface DTPhotoBaseController ()

@end

@implementation DTPhotoBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //去掉半透明
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupNavbar];
}

#pragma mark - 导航栏
- (void)setupNavbar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38/255.0 green:184/255.0 blue:243/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if (self.navigationController.viewControllers.count > 1)
    {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Back"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"DTPhotoPicker.bundle/Back"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationTitle:(NSString *)title
{
    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
