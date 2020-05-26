//
//  RACCommand+CPNetExtension.h
//  CPNetManger_Demo
//
//  Created by Mac on 2020/5/26.
//  Copyright © 2020 MAC. All rights reserved.
//
 
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACCommand (CPNetExtension)

/// 网络请求保留字段
@property (nonatomic , strong) id netExtension;

/// 任务
@property (nonatomic , strong) NSURLSessionTask *task;

@end

NS_ASSUME_NONNULL_END
