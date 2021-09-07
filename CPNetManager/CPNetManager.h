//
//  CPNetManger.h
//  Hotel
//
//  Created by chenp on 2017/6/7.
//  Copyright © 2017年 zhu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CPNetRequest.h"

@interface CPNetManager : NSObject

/// 网络检测
+ (void)networkReachabilityStart;

/// 显示日志
+ (void)showLogs;

/// 添加请求头 添加一次就好
+ (void)addHeadHTTPHeaderField:(NSDictionary * _Nullable)dic;

/// 更新网络请求中code的标识，默认@"code"
+ (void)changeCodeForNewCodeKey:(NSString * _Nonnull)codeKey;

/// 更新网络请求中Message的标识，默认@"message"
+ (void)changeMessageForNewMessageKey:(NSString * _Nonnull)messageKey;

/// 添加请求成功时，codes的值（默认为@[@"1"]）,会清空原有的codes
+ (void)addResponseObjectCodes:(NSArray<NSString *> * _Nonnull)codes;

/// 添加json请求的链接的关键字，内部会自行判断  添加一次就好
+ (void)addRequestJsonUrl:(NSString * _Nonnull)url;

/// 所有请求添加到json请求
+ (void)allRequestForJson;

/// 传入token过期标识
+ (void)addTokenCodes:(NSArray<NSString *> *_Nonnull)tokenCodes tokenOverdue:(CPNetRequestTokenOverdueBlock _Nullable)tokenOverdueBlock;

/// 请求任务添加
+ (void)addCommandTask:(RACCommand * _Nonnull)command;

/// 请求任务移除
+ (void)removeCommandTask:(RACCommand * _Nonnull)command;

/// 全部任务开始请求
+ (void)startAllDataTaskRequest;

/// 暂停全部任务
+ (void)stopAllDataTaskRequest;

/// 取消全部任务
+ (void)cancelAllDataTaskRequest;

/// 停止所有下载任务
+ (void)stopAllDownTask;

/// 停止某个下载任务
+ (void)stopDownFileTask:(NSURLSessionDownloadTask * _Nullable)task;

/******************************************************************
 普通网络请求
 ******************************************************************/

+(NSURLSessionTask * _Nonnull)POST:(NSString * _Nonnull)urlStr
                        parameters:(NSDictionary * _Null_unspecified)dictionary
                           success:(CPNetRequestSuccess _Nonnull)success
                           failure:(CPNetRequestFailure _Null_unspecified)failure;

+(NSURLSessionTask * _Nonnull)GET:(NSString * _Nonnull)urlStr
                       parameters:(NSDictionary * _Null_unspecified)dictionary
                          success:(CPNetRequestSuccess _Nonnull)success
                          failure:(CPNetRequestFailure _Null_unspecified)failure;

+(NSURLSessionTask * _Nonnull)PUT:(NSString * _Nonnull)urlStr
                       parameters:(NSDictionary * _Null_unspecified)dictionary
                          success:(CPNetRequestSuccess _Nonnull)success
                          failure:(CPNetRequestFailure _Null_unspecified)failure;

+(NSURLSessionTask * _Nonnull)PATCH:(NSString * _Nonnull)urlStr
                         parameters:(NSDictionary * _Null_unspecified)dictionary
                            success:(CPNetRequestSuccess _Nonnull)success
                            failure:(CPNetRequestFailure _Null_unspecified)failure;

+(NSURLSessionTask * _Nonnull)DEL:(NSString * _Nonnull)urlStr
                       parameters:(NSDictionary * _Null_unspecified)dictionary
                          success:(CPNetRequestSuccess _Nonnull)success
                          failure:(CPNetRequestFailure _Null_unspecified)failure;

/******************************************************************
 文件上传
 ******************************************************************/

/**
 多个文件上传
 
 @param urlStr url地址
 @param dictionary 参数
 @param dataModels 要上传的数据模型数组
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 */
+(NSURLSessionTask * _Nonnull)POST:(NSString * _Nonnull)urlStr
                        parameters:(NSDictionary * _Null_unspecified)dictionary
                        dataModels:(NSArray<CPDataModel *> * _Nonnull)dataModels
                          progress:(CPNetRequestDownProgress _Null_unspecified)progress
                           success:(CPNetRequestSuccess _Nonnull)success
                           failure:(CPNetRequestFailure _Null_unspecified)failure;



/******************************************************************
 文件下载
 ******************************************************************/

/**
 文件下载
 @param urlStr 下载地址
 @param progress 进度
 @param destination 存储目的地
 @param completionHandler 完成操作
 @return 返回类型
 手动开启 关闭  暂停
 */
+(NSURLSessionDownloadTask * _Nonnull)downloadUrl:(NSString *_Nonnull)urlStr
                                         progress:(CPNetRequestDownProgress _Null_unspecified)progress
                                      destination:(CPNetRequestDestination _Nonnull)destination
                                completionHandler:(CPNetRequestDownCompletionHandler _Nonnull)completionHandler;

 
@end

