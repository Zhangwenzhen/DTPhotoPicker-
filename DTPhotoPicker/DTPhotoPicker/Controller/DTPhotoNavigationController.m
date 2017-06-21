//
//  DTPhotoNavigationController.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/21.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoNavigationController.h"

@interface DTPhotoNavigationController ()

@end

@implementation DTPhotoNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//横竖屏设置
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
