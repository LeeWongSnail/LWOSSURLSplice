//
//  CropResultImageViewController.m
//  OSSURLStitchingDemo
//
//  Created by LeeWong on 2018/10/20.
//  Copyright © 2018年 ws. All rights reserved.
//

#import "CropResultImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>
@interface CropResultImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CropResultImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@400);
        make.centerY.equalTo(self.view.mas_centerY);
    }];

    self.imageView = [[UIImageView alloc] init];
    [bgView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(300));
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_centerY);
    }];

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(@(image.size));
                make.centerX.equalTo(bgView.mas_centerX);
                make.centerY.equalTo(bgView.mas_centerY);
            }];
        });
    }];
}



@end
