//
//  OSSImageMaker.h
//  UXLive
//
//  Created by LeeWong on 2018/8/7.
//  Copyright © 2018年 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULOSSImageResize.h"
@interface ULOSSImageMaker : NSObject

- (instancetype)initWithBaseURLString:(NSString *)aURLString;

- (ULOSSImageResize *)resize;


@end
