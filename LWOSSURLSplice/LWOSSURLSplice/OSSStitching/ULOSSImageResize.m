//
//  ULOSSImageResize.m
//  UXLive
//
//  Created by LeeWong on 2018/8/7.
//  Copyright © 2018年 UXIN CO. All rights reserved.
//

#import "ULOSSImageResize.h"
#import "NSString+OSSImageMaker.h"
#import <UIKit/UIKit.h>



static NSString *const oss_w = @"w_";
static NSString *const oss_h = @"h_";
static NSString *const oss_p = @"p_";
static NSString *const oss_limit = @"limit_";
static NSString *const oss_color = @"color_";
static NSString *const oss_mfit = @"m_mfit";
static NSString *const oss_lift = @"m_lfit";
static NSString *const oss_fill = @"m_fill";
static NSString *const oss_pad = @"m_pad";
static NSString *const oss_fixed = @"m_fixed";
static NSString *const oss_format = @"/format,png";
static NSString *const oss_circle = @"/circle,r_";
static NSString *const oss_rounded_corners = @"/rounded-corners,r_";

static NSString *const oss_blur_r = @"/blur,r_";
static NSString *const oss_blur_s = @"s_";

static CGFloat const kCommonScale = 9.0/16.0;

@interface ULOSSImageResize ()
@property (nonatomic, copy) NSString *baseURLString;
//阿里云的一些属性
@property(nonatomic, assign) ULOSSImageResizeContentModelType   imageContentModelType;
@property(nonatomic, strong) NSNumber   *oss_w;
@property(nonatomic, strong) NSNumber   *oss_h;
@property(nonatomic, strong) NSNumber   *oss_p;
@property(nonatomic, strong) NSNumber   *oss_limit;
@property(nonatomic, strong) NSString   *oss_color;
@property (nonatomic, strong) NSNumber *oss_circle;
@property (nonatomic, strong) NSNumber *oss_rounded_corners;
@property (nonatomic, strong) NSNumber *oss_blur_r;
@property (nonatomic, strong) NSNumber *oss_blur_s;

@property (nonatomic, assign) CGFloat curScale;
@property (nonatomic, assign) ULOSSHeaderImageType headerType;
@end

@implementation ULOSSImageResize

- (instancetype)initWithBaseURLString:(NSString *)aURLString
{
    if (self = [super init]) {
        self.baseURLString = aURLString;
    }
    return self;
}

- (ULResizeHandler)width
{
    return ^(NSNumber *attr) {
        self.oss_w = [NSNumber numberWithFloat:attr.floatValue*self.curScale];
        [self addOSSImageAttributeValue:self.oss_w.stringValue type:oss_w];
        return self;
    };
}


- (ULResizeHandler)height
{
    return ^(NSNumber *attr) {
        self.oss_h = [NSNumber numberWithFloat:attr.floatValue*self.curScale];
        [self addOSSImageAttributeValue:self.oss_h.stringValue type:oss_h];
        return self;
    };
}


- (ULResizeHandler)contentMode
{
    return ^(NSNumber *attr) {
        self.imageContentModelType = attr.integerValue;
        [self addOSSImageAttributeValue:@"" type:[self contentModeTypeToString]];
        return self;
    };
}


- (ULResizeHandler)circle
{
    return ^(NSNumber *attr) {
        self.oss_circle = attr;
        [self addOSSImageAttributeValue:self.oss_circle.stringValue type:oss_circle];
        return self;
    };
}


- (ULResizeHandler)roundedCorners
{
    return ^(NSNumber *attr) {
        self.oss_rounded_corners = attr;
        [self addOSSImageAttributeValue:self.oss_rounded_corners.stringValue type:oss_rounded_corners];
        return self;
    };
}

- (ULFormatHandler)formatPNG
{
    return ^() {
        [self addOSSImageAttributeValue:@"" type:oss_format];
        return self;
    };
}

- (ULEffectHandler)blur
{
    return ^(NSNumber *r,NSNumber *s) {
        self.oss_blur_r = r;
        self.oss_blur_s = s;
        
        [self addOSSImageAttributeValue:self.oss_blur_r.stringValue type:oss_blur_r];
        [self addOSSImageAttributeValue:self.oss_blur_s.stringValue type:oss_blur_s];
        
        return self;
    };
}

- (ULFormatHandler)commondSquareImage {
    return ^() {
        // 先保证之前已经设置了宽度
        NSAssert(self.oss_w, @"使用commondSquareImage, 必须先调用width,配置宽度");
        CGFloat height = @(self.oss_w.floatValue / kCommonScale).integerValue;
        [self addOSSImageAttributeValue:@(height).stringValue type:oss_h];
        return self;
    };
}

- (ULResizeHandler)heightWithScale {
    return ^(NSNumber *attr) {
        // 根据之前传入的宽度和本次传入的比例设置高度
        NSAssert(self.oss_w, @"使用heightWithScale, 必须先调用width,配置宽度");
        CGFloat height = @(self.oss_w.floatValue / attr.floatValue).integerValue;
        [self addOSSImageAttributeValue:@(height).stringValue type:oss_h];
        return self;
    };
}

- (ULResizeHandler)widthAndHeight {
    return ^(NSNumber *attr) {
        // 宽高相同
        self.oss_w = [NSNumber numberWithFloat:attr.floatValue*self.curScale];
        self.oss_h = [NSNumber numberWithFloat:attr.floatValue*self.curScale];
        [self addOSSImageAttributeValue:self.oss_w.stringValue type:oss_w];
        [self addOSSImageAttributeValue:self.oss_h.stringValue type:oss_h];

        return self;
    };
}

- (ULResizeColorHandler)color
{
    return ^(NSString *attr) {
        NSAssert(attr, @"配置16进制色值");
        [self addOSSImageAttributeValue:attr type:oss_color];
        self.oss_color = attr;
        return self;
    };
}

- (void)addOSSImageAttributeValue:(NSString *)atrri type:(NSString *)type
{
    NSString *tem = [NSString stringWithFormat:@",%@%@", type, atrri];
    self.baseURLString = [self.baseURLString stringByAppendingString:tem];
}

- (NSString *)resultString
{
    return self.baseURLString;
}

#pragma mark - 新增的几个类型的图片
- (NSString *)userCircleAvatarImageURLString {
    CGFloat headerWH = 0;
    switch (self.headerType) {
        case ULOSSHeaderImageType30:
            headerWH = 30;
            break;
        case ULOSSHeaderImageType60:
            headerWH = 60;
            break;
        case ULOSSHeaderImageType90:
            headerWH = 90;
            break;
        default:
            headerWH = 90;
            break;
    }
    return self.contentMode(@(ULOSSImageResizeContentModelTypeMfit)).width(@(headerWH)).height(@(headerWH)).circle(@(headerWH)).formatPNG().resultString;
}



#pragma mark - 根据屏幕的Scal来计算
- (CGFloat)curScale
{
    return  [UIScreen mainScreen].scale;
}

#pragma mark - OSSImageContentModel 转字符串

- (ULResizeHandler)resizeHeaderType {
    return ^(NSNumber *attr) {
        self.headerType = [attr integerValue];
        return self;
    };
}

- (NSString *)contentModeTypeToString
{
    NSString *result = nil;
    switch (self.imageContentModelType) {
        case ULOSSImageResizeContentModelTypeMfit:
            result = oss_mfit;
            break;
        case ULOSSImageResizeContentModelTypeLfit:
            result = oss_lift;
            break;
        case ULOSSImageResizeContentModelTypeFixed:
            result = oss_fixed;
            break;
        case ULOSSImageResizeContentModelTypePad:
            result = oss_pad;
            break;
        case ULOSSImageResizeContentModelTypeFill:
            result = oss_fill;
            break;
        default:
            result = @"";
            break;
    }
    
    return result;
}
@end

