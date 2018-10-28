//
//  OSSImageMaker.m
//  UXLive
//
//  Created by LeeWong on 2018/8/7.
//  Copyright © 2018年 UXIN CO. All rights reserved.
//

#import "ULOSSImageMaker.h"

static NSString *URL_ANDMARK = @"&";
static NSString *URL_QUESTIONMARK = @"?";

@interface ULOSSImageMaker ()
@property (nonatomic, copy) NSString *baseURLString;
@end

@implementation ULOSSImageMaker

- (instancetype)initWithBaseURLString:(NSString *)aURLString
{
    if (self = [super init]) {
        if ([aURLString rangeOfString:URL_QUESTIONMARK].length > 0) {
            self.baseURLString = [NSString stringWithFormat:@"%@%@x-oss-process=image",aURLString,URL_ANDMARK];
        } else {
            self.baseURLString = [NSString stringWithFormat:@"%@%@x-oss-process=image",aURLString,URL_QUESTIONMARK];
        }
    }
    return self;
}

- (ULOSSImageResize *)resize
{
    NSString *actionString = [self.baseURLString stringByAppendingString:@"/resize"];
    ULOSSImageResize *action = [[ULOSSImageResize alloc] initWithBaseURLString:actionString];
    return action;
}

@end
