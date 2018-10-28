//
//  ULOSSImageResize.h
//  UXLive
//
//  Created by LeeWong on 2018/8/7.
//  Copyright © 2018年 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULOSSImageResize;

typedef NS_ENUM(NSInteger, ULOSSImageResizeContentModelType) {
    ULOSSImageResizeContentModelTypeLfit, //等比缩放，限制在指定w与h的矩形内的最大图片
    ULOSSImageResizeContentModelTypeMfit, //等比缩放，延伸出指定w与h的矩形框外的最小图片
    ULOSSImageResizeContentModelTypePad,  //固定宽高，将延伸出指定w与h的矩形框外的最小图片进行居中裁剪
    ULOSSImageResizeContentModelTypeFixed,   //固定宽高，缩略填充。
    ULOSSImageResizeContentModelTypeFill  //固定宽高，强制缩略
};

typedef ULOSSImageResize *(^ULResizeHandler) (NSNumber *attribute);
typedef ULOSSImageResize *(^ULResizeColorHandler) (NSString *attribute);
typedef ULOSSImageResize *(^ULFormatHandler) (void);
typedef ULOSSImageResize *(^ULEffectHandler) (NSNumber *r,NSNumber *s);

@interface ULOSSImageResize : NSObject

/**
 初始化方法
 
 @param string 图片的基本地址(未添加切图标识的)
 @return    OSSImageResize
 */
- (instancetype)initWithBaseURLString:(NSString *)aURLString;

/**
 图片宽度固定
 
 @return ResizeHandler
 */
- (ULResizeHandler)width;


/**
 图片高度固定
 
 @return ResizeHandler
 */
- (ULResizeHandler)height;


/**
 图片的填充模式
 
 @return ResizeHandler
 */
- (ULResizeHandler)contentMode;


/**
 图片内切圆
 
 @return ResizeHandler
 */
- (ULResizeHandler)circle;


/**
 图片圆角
 
 @return ResizeHandler
 */
- (ULResizeHandler)roundedCorners;


/**
 强制格式化图片
 
 @return FormatHandler
 */
- (ULFormatHandler)formatPNG;

/**
 图片模糊特效
 
 @return    EffectHandler
 */
- (ULEffectHandler)blur;

/**
 设置头像类型

 @return FormatHandler
 */
- (ULResizeHandler)resizeHeaderType;


/**
 设置 9/16宽图的方法

 @return 根据之前传入的宽度自动计算高度后返回的图片地址
 */
- (ULFormatHandler)commondSquareImage;


/**
 根据之前指定的宽度和本次指定的比例设置高度

 @return return value description
 */
- (ULResizeHandler)heightWithScale;

- (ULResizeHandler)widthAndHeight;

- (ULResizeColorHandler)color;

/**
 最终生成的图片地址
 
 @return 图片地址
 */
- (NSString *)resultString;

/**
 获取用户圆的头像

 @return 图片地址
 */
- (NSString *)userCircleAvatarImageURLString;


@end
