//
//  CPNetRequest.h
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CPDataModel.h"

typedef enum : NSUInteger {
    //蜂窝、无线
    CPNetType_WWANOrWiFi,
    //无网情况
    CPNetType_Unknown,
} CPNetType;//网络类型

typedef void(^CPNetRequestSuccess)(NSDictionary *  _Nullable responseObject , NSURLSessionDataTask * _Nonnull task);
typedef void(^CPNetRequestFailure)(NSDictionary *  _Nullable responseObject , NSString * _Nullable message , NSString * _Nullable code , NSURLSessionDataTask * _Nonnull task);
typedef NSURL * _Nonnull(^CPNetRequestDestination)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);
typedef void(^CPNetRequestDownProgress)(CGFloat uploadProgress);
typedef void(^CPNetRequestDownCompletionHandler)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);
typedef void(^CPNetRequestTokenOverdueBlock)(BOOL * _Nonnull flag);

@interface CPNetRequest : AFHTTPSessionManager

/// 当前网络类型
@property (nonatomic , assign) CPNetType type;

/// 初始化
+(CPNetRequest *_Nullable)getManager;

/// 显示日志
- (void)showLogs;

/// 添加请求头 添加一次就好
- (void)addHeadHTTPHeaderField:(NSDictionary *_Nullable)dic;

/// 更新网络请求中code的标识
- (void)changeCodeForNewCodeKey:(NSString * _Nonnull)codeKey;

/// 更新网络请求中Message的标识
- (void)changeMessageForNewMessageKey:(NSString * _Nonnull)messageKey;

/// 添加请求成功时，codes的值（默认为@[@"1"]）
- (void)addResponseObjectCodes:(NSArray<NSString *> * _Nonnull)codes;

/// 添加json请求的链接的关键字，内部会自行判断  添加一次就好
- (void)addRequestJsonUrl:(NSString *_Nonnull)url;

/// 所有请求添加到json请求
- (void)allRequestForJson;

/// 传入token过期标识
/// @param tokenCodes token过期对应的codes
/// @param tokenOverdueBlock 发现token过期时的回调
- (void)addTokenCodes:(NSArray<NSString *> *_Nonnull)tokenCodes tokenOverdue:(CPNetRequestTokenOverdueBlock _Nullable)tokenOverdueBlock;

/// 请求任务添加
- (void)addCommandTask:(RACCommand *_Nonnull)command;

/// 请求任务移除
- (void)removeCommandTask:(RACCommand *_Nonnull)command;

/// 全部任务开始请求
- (void)startAllDataTaskRequest;

/// 暂停全部任务
- (void)stopAllDataTaskRequest;

/// 取消全部任务
- (void)cancelAllDataTaskRequest;


/******************************************************************
 网络请求
 ******************************************************************/

- (NSURLSessionDataTask  * _Nonnull)CPPOST:(NSString * _Nonnull)urlStr
                                parameters:(NSDictionary * _Null_unspecified)dictionary
                                   success:(CPNetRequestSuccess _Nonnull)success
                                   failure:(CPNetRequestFailure _Null_unspecified)failure;

- (NSURLSessionDataTask * _Nonnull)CPGET:(NSString * _Nonnull)urlStr
                              parameters:(NSDictionary * _Null_unspecified)dictionary
                                 success:(CPNetRequestSuccess _Nonnull)success
                                 failure:(CPNetRequestFailure _Null_unspecified)failure;

- (NSURLSessionDataTask * _Nonnull)CPPUT:(NSString * _Nonnull)urlStr
                              parameters:(NSDictionary * _Null_unspecified)dictionary
                                 success:(CPNetRequestSuccess _Nonnull)success
                                 failure:(CPNetRequestFailure _Null_unspecified)failure;

- (NSURLSessionDataTask * _Nonnull)CPPATCH:(NSString * _Null_unspecified)urlStr
                                parameters:(NSDictionary * _Null_unspecified)dictionary
                                   success:(CPNetRequestSuccess _Null_unspecified)success
                                   failure:(CPNetRequestFailure _Null_unspecified)failure;

- (NSURLSessionDataTask * _Nonnull)CPDEL:(NSString * _Nonnull)urlStr
                              parameters:(NSDictionary * _Null_unspecified)dictionary
                                 success:(CPNetRequestSuccess _Nonnull)success
                                 failure:(CPNetRequestFailure _Null_unspecified)failure;

/******************************************************************
 文件上传
 ******************************************************************/
- (NSURLSessionDataTask * _Nonnull)CPPOST:(NSString * _Nonnull)urlStr
                               parameters:(NSDictionary * _Null_unspecified)dictionary
                               dataModels:(NSArray<CPDataModel *> * _Nonnull)dataModels
                                 progress:(CPNetRequestDownProgress _Null_unspecified)progress
                                  success:(CPNetRequestSuccess _Nonnull)success
                                  failure:(CPNetRequestFailure _Null_unspecified)failure;

/******************************************************************
 文件下载
******************************************************************/
- (NSURLSessionDownloadTask * _Nonnull)CPdownloadUrl:(NSString *_Nonnull)urlStr
                                            progress:(CPNetRequestDownProgress _Null_unspecified)progress
                                         destination:(CPNetRequestDestination _Nonnull)destination
                                   completionHandler:(CPNetRequestDownCompletionHandler _Nonnull)completionHandler;


/// 暂停所有请求
- (void)stopAllDownFileTask;

/// 停止某个任务
- (void)stopDownFileTask:(NSURLSessionDownloadTask * _Nullable)task;

@end

