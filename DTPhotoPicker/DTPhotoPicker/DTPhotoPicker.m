//
//  DTPhotoPicker.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/16.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "DTPhotoPicker.h"
#import "DTPhotoCenter.h"
#import "DTPhotoManager.h"
#import "DTPhotoAblumListController.h"

#import "DTPhotoNavigationController.h"

@interface DTPhotoPicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imaPic;

@property (nonatomic, strong) DTPhotoPickerCameraBlock cameraBlock;

@end

@implementation DTPhotoPicker

//懒加载
- (UIImagePickerController *)imaPic
{
    if (!_imaPic)
    {
        _imaPic = [[UIImagePickerController alloc] init];
        _imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imaPic.delegate = self;
    }
    return _imaPic;
}
- (id)init
{
    if (self = [super init])
    {
        [self configData];
    }
    return self;
}

- (void)configData
{
    if (self.selectedCount <= 0)
    {
        self.selectedCount = 20;
    }
    

    [DTPhotoCenter shareCenter].selectedCount = self.selectedCount;
}


- (void)setSelectedCount:(NSInteger)selectedCount
{
    _selectedCount = selectedCount;
    
    [DTPhotoCenter shareCenter].selectedCount = selectedCount;
}


- (void)showInSender:(UIViewController *)sender pickedImagesFromPhotoLibrary:(void(^)(NSArray<UIImage *> * photos))handle
{
    [DTPhotoCenter shareCenter].handle = handle;
    
    [[DTPhotoCenter shareCenter] photoLibaryAuthorizationValidWithHandle:^{
        
        DTPhotoAblumListController *ablumsList = [[DTPhotoAblumListController alloc] init];
        ablumsList.assetCollections = [[DTPhotoManager manager] getAllAblums];
        
        DTPhotoNavigationController * NVC = [[DTPhotoNavigationController alloc]initWithRootViewController:ablumsList];
        [sender presentViewController:NVC animated:YES completion:nil];
    }];
    
}


- (void)showInSender:(UIViewController *)sender pickedImagesFromCamera:(DTPhotoPickerCameraBlock)handle
{
    [[DTPhotoCenter shareCenter] cameraAuthoriationValidWithHandle:^{
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                     message:@"启动相机失败"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action)
                                          {
                                              
                                          }];
            
            [alertController addAction:alertAction];
            [sender presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        [sender presentViewController:self.imaPic animated:YES completion:nil];
    }];
    
    self.cameraBlock = handle;
}


//跳出提示框
- (void)addAlertControllerWithTitle:(NSString *)title
                            message:(NSString *)message
                         controller:(UIViewController *)controller
                    isHandlerAction:(BOOL)isHandlerAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      if (isHandlerAction == YES)
                                      {
                                          //跳到系统“隐私”界面
                                          [self gotoImageSetting];
                                      }
                                  }];
    
    [alertController addAction:alertAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

//跳到系统“隐私”界面
- (void)gotoImageSetting
{
    NSString * urlString = @"App-Prefs:root=Privacy";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]])
    {
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            
        } else
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        
    }
}

#pragma mark ------------ UIImagePickerControllerDelegate ------------

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //把图片存入相册
    
    self.cameraBlock(image);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
