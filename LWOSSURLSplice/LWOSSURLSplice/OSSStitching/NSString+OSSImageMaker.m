//
//  NSString+OSSImageMaker.m
//  UXLive
//
//  Created by LeeWong on 2018/8/7.
//  Copyright © 2018年 UXIN CO. All rights reserved.
//

#import "NSString+OSSImageMaker.h"
#import <objc/runtime.h>

static char makerName;

@implementation NSString (OSSImageMaker)

- (ULOSSImageMaker *)ul_maker
{
    if (!objc_getAssociatedObject(self, &makerName)) {
        ULOSSImageMaker  *maker = [[ULOSSImageMaker alloc] initWithBaseURLString:self];
        objc_setAssociatedObject(self, &makerName, maker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &makerName);
}
@end
