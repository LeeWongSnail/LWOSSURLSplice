//
//  ViewController.m
//  OSSURLStitchingDemo
//
//  Created by LeeWong on 2018/10/20.
//  Copyright © 2018年 ws. All rights reserved.
//

#import "ViewController.h"
#import "CropResultImageViewController.h"
#import "NSString+OSSImageMaker.h"
#import "ULOSSImageResize.h"
#import <Masonry.h>

static NSString  *origin = @"原图";
static NSString  *rounder = @"切圆角";
static NSString  *circle = @"切圆形";
static NSString  *onlyWidth = @"单设宽度";
static NSString  *onlyheight = @"单设高度";
static NSString  *fixWidthHeight = @"设置固定宽高";
static NSString  *ratioScaleInView = @"等比缩放, 限定在矩形框内";
static NSString  *ratioScalInViewShortFirst = @"等比缩放, 限定在矩形框内 短边优先";
static NSString  *fixWidthHeightCrop = @"固定宽高，自动裁剪";
static NSString  *minizeFill = @"缩略填充";



static NSString  *height169 = @"设置宽度(高度默认16/9)";
static NSString  *heightandratio = @"设置宽度和宽高比";
static NSString  *blur = @"设置模糊效果";

//http://img.hongrenshuo.com.cn/20893034373361540005858212006786.png&x-oss-process=image/resize,w_200,h_355.5555555555555
//http://img.hongrenshuo.com.cn/20893034373361540005858212006786.png?x-oss-process=image/resize,m_mfit,h_464,w_336
static NSString *imageURLString = @"http://img.hongrenshuo.com.cn/20893034373361540005858212006786.png";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildUI];
    self.title = @"OSSURLStitchingDemo";
}

- (void)buildUI {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataList[indexPath.row];

    NSString *imageURL = nil;
    if ([title isEqualToString:rounder]) {
        imageURL = imageURLString.ul_maker.resize.width(@100).height(@100).roundedCorners(@10).resultString;
    } else if ([title isEqualToString:circle]) {
        imageURL = imageURLString.ul_maker.resize.width(@100).height(@100).circle(@50).resultString;
    } else if ([title isEqualToString:onlyWidth]) {
        imageURL = imageURLString.ul_maker.resize.width(@50).resultString;
    } else if ([title isEqualToString:onlyheight]) {
        imageURL = imageURLString.ul_maker.resize.height(@150).resultString;
    } else if ([title isEqualToString:ratioScaleInView]) {
        imageURL = imageURLString.ul_maker.resize.width(@100).height(@20).contentMode(@(ULOSSImageResizeContentModelTypeLfit)).resultString;
    } else if ([title isEqualToString:ratioScalInViewShortFirst]) {
        imageURL = imageURLString.ul_maker.resize.widthAndHeight(@150).contentMode(@(ULOSSImageResizeContentModelTypeMfit)).resultString;
    } else if ([title isEqualToString:fixWidthHeightCrop]) {
        imageURL = imageURLString.ul_maker.resize.widthAndHeight(@100).contentMode(@(ULOSSImageResizeContentModelTypeFill)).resultString;
    } else if ([title isEqualToString:minizeFill]) {
        imageURL = imageURLString.ul_maker.resize.widthAndHeight(@150).contentMode(@(ULOSSImageResizeContentModelTypePad)).color(@"00ff00").resultString;
    } else if ([title isEqualToString:fixWidthHeight]) {
        imageURL = imageURLString.ul_maker.resize.width(@100).height(@100).contentMode(@(ULOSSImageResizeContentModelTypeFixed)).resultString;
    } else if ([title isEqualToString:height169]) {
        imageURL = imageURLString.ul_maker.resize.width(@100).commondSquareImage().contentMode(@(ULOSSImageResizeContentModelTypeFixed)).resultString;
    } else if ([title isEqualToString:heightandratio]) {
        imageURL = imageURLString.ul_maker.resize.width(@50).heightWithScale(@0.3).contentMode(@(ULOSSImageResizeContentModelTypeFixed)).resultString;
    }  else if ([title isEqualToString:blur]) {
        imageURL = imageURLString.ul_maker.resize.widthAndHeight(@100).blur(@(5),@(6)).resultString;
    } else if ([title isEqualToString:origin]) {
        imageURL = imageURLString;
    }


    CropResultImageViewController *cropVC =[[CropResultImageViewController alloc] init];
    cropVC.title = self.dataList[indexPath.row];
    cropVC.imageURLString = imageURL;
    [self.navigationController pushViewController:cropVC animated:YES];
}

#pragma mark - Lazy Load



- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.rowHeight = 44;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)dataList {
    if (_dataList == nil) {
        _dataList = @[origin,rounder,circle,onlyWidth,onlyheight,fixWidthHeight,ratioScaleInView,ratioScalInViewShortFirst,fixWidthHeightCrop,minizeFill,height169,heightandratio,blur];
    }
    return _dataList;
}

@end
