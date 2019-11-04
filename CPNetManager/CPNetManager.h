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


/**
 网络检测
 */
+(void)networkReachabilityStart;
 
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

