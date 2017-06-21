//
//  ViewController.m
//  DTPhotoPicker
//
//  Created by 张文臻 on 2017/6/16.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "ViewController.h"
#import "DTPhotoPicker.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray;

@property (nonatomic, assign) NSUInteger currentImageIndex;

@property (weak, nonatomic) IBOutlet UILabel *imagesCountLabel;

@property (nonatomic, strong) DTPhotoPicker *picker;



@end

@implementation ViewController

//懒加载数组
- (NSMutableArray *)imagesArray
{
    if (!_imagesArray)
    {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.picker = [[DTPhotoPicker alloc] init];
    
}






//上传照片
- (IBAction)uploadImage:(UIButton *)sender
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    UIAlertAction *pzAction = [UIAlertAction actionWithTitle:@"拍照"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   
                                   [self getImageFromCamera];
                               }];
    [alertC addAction:pzAction];
    
    
    UIAlertAction *xcAction = [UIAlertAction actionWithTitle:@"相册中选择"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [self getImagesFromPhotoLibrary];
                               }];
    
    [alertC addAction:xcAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    [alertC addAction:cancelAction];
}

//从相机中获取图片数组
- (void)getImageFromCamera
{
    [self.picker showInSender:self pickedImagesFromCamera:^(UIImage *image)
    {
        NSLog(@"拍照返回图片");
        self.imageView.image = image;
        self.imagesCountLabel.text = @"当前有1张图片";
    }];
}

//从相册中获取图片数组
- (void)getImagesFromPhotoLibrary
{
//    DTPhotoPicker *picker = [[DTPhotoPicker alloc] init];
    NSLog(@"图片数组个数:%ld",self.imagesArray.count);
    
    NSUInteger maxCount = 10 - self.imagesArray.count;
    NSLog(@"可上传图片个数:%ld",maxCount);
    self.picker.selectedCount = maxCount;
    
    [self.picker showInSender:self pickedImagesFromPhotoLibrary:^(NSArray<UIImage *> *photos)
    {
        NSLog(@"返回图片个数:%ld",photos.count);

        [self.imagesArray addObjectsFromArray:photos];
        
        self.imageView.image = self.imagesArray.firstObject;
        self.currentImageIndex = 0;
        
        self.imagesCountLabel.text = [NSString stringWithFormat:@"当前有%ld张图片",self.imagesArray.count];
    }];
}

//上一张图片
- (IBAction)previousImage:(UIButton *)sender
{
    if (self.currentImageIndex == 0)
    {
        self.imageView.image = self.imagesArray.firstObject;
    }
    else
    {
        self.currentImageIndex--;
        self.imageView.image = self.imagesArray[self.currentImageIndex];
    }
}
//下一张图片
- (IBAction)nextImage:(UIButton *)sender
{
    if (self.currentImageIndex == self.imagesArray.count-1)
    {
        self.imageView.image = self.imagesArray.lastObject;
    }
    else
    {
        self.currentImageIndex++;
        self.imageView.image = self.imagesArray[self.currentImageIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
