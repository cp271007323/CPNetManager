//
//  NSURLSessionDownloadTask+CPNetRequestUrl.m
//  CPNetManger_Demo
//
//  Created by Mac on 2020/11/19.
//  Copyright © 2020 MAC. All rights reserved.
//

#import "NSURLSessionDownloadTask+CPNetRequestUrl.h"
#import <objc/message.h>

@implementation NSObject (CPNetRequestUrl)

- (void)setCPNetRequestUrl:(NSString *)CPNetRequestUrl
{
    objc_setAssociatedObject(self, @selector(CPNetRequestUrl), CPNetRequestUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)CPNetRequestUrl
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
