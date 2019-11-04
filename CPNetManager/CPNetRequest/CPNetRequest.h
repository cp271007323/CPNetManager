//
//  CPNetRequest.h
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CPDataModel.h"

typedef enum : NSUInteger {
    CPNetType_WWANOrWiFi,
    CPNetType_Unknown,
} CPNetType;

typedef void(^CPNetRequestSuccess)(NSDictionary *  _Nullable responseObject , NSURLSessionDataTask * _Nonnull task);
typedef void(^CPNetRequestFailure)(NSString * _Nullable message , NSString * _Nullable code , NSURLSessionDataTask * _Nonnull task);
typedef NSURL * _Nonnull(^CPNetRequestDestination)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);
typedef void(^CPNetRequestDownProgress)(CGFloat uploadProgress);
typedef void(^CPNetRequestDownCompletionHandler)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);


@interface CPNetRequest : AFHTTPSessionManager

/// 当前网络类型
@property (nonatomic , assign) CPNetType type;

/// 初始化
+(CPNetRequest *_Nullable)getManager;

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

- (NSURLSessionDataTask * _Nonnull)CPPOST:(NSString * _Nonnull)urlStr
                      parameters:(NSDictionary * _Null_unspecified)dictionary
                      dataModels:(NSArray<CPDataModel *> * _Nonnull)dataModels
                        progress:(CPNetRequestDownProgress _Null_unspecified)progress
                         success:(CPNetRequestSuccess _Nonnull)success
                         failure:(CPNetRequestFailure _Null_unspecified)failure;

- (NSURLSessionDownloadTask * _Nonnull)CPdownloadUrl:(NSString *_Nonnull)urlStr
                                            progress:(CPNetRequestDownProgress _Null_unspecified)progress
                                         destination:(CPNetRequestDestination _Nonnull)destination
                                   completionHandler:(CPNetRequestDownCompletionHandler _Nonnull)completionHandler;

- (void)addRequestSerializerHead:(NSString * _Null_unspecified)urlStr;

- (void)responseObject:(id  _Nullable)responseObject
                 task:(NSURLSessionDataTask * _Nonnull)task
              success:(CPNetRequestSuccess _Nullable )success
              failure:(CPNetRequestFailure _Nullable )failure;

- (void)failObject:(NSError * _Nullable)error
             task:(NSURLSessionDataTask * _Nonnull)task
          failure:(CPNetRequestFailure _Nonnull )failure;
@end

