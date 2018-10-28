//
//  NSString+OSSImageMaker.h
//  UXLive
//
//  Created by LeeWong on 2018/8/7.
//  Copyright © 2018年 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULOSSImageMaker.h"

typedef NS_ENUM(NSInteger, ULOSSHeaderImageType) {
    ULOSSHeaderImageType30 = 0,
    ULOSSHeaderImageType60 = 1,
    ULOSSHeaderImageType90 = 2
};

@interface NSString (OSSImageMaker)
- (ULOSSImageMaker *)ul_maker;
@end
