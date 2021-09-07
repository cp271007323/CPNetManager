//
//  RACCommand+CPNetExtension.m
//  CPNetManger_Demo
//
//  Created by Mac on 2020/5/26.
//  Copyright © 2020 MAC. All rights reserved.
//

#import "RACCommand+CPNetExtension.h"
 #import <Objc/runtime.h>

@implementation RACCommand (CPNetExtension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method old_method1 = class_getInstanceMethod(self, @selector(execute:));
        Method new_method1 = class_getInstanceMethod(self, @selector(cpExecute:));
        method_exchangeImplementations(old_method1, new_method1);
    });
}

- (RACSignal *)cpExecute:(id)input
{
    self.netExtension = input;
    return [self cpExecute:input];
}

- (void)setNetExtension:(id)netExtension
{
    objc_setAssociatedObject(self, @selector(netExtension), netExtension, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)netExtension
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTask:(NSURLSessionTask *)task
{
    objc_setAssociatedObject(self, @selector(task), task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURLSessionTask *)task
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
