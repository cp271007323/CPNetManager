//
//  CPNetRequest.m
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import "CPNetRequest.h"

//请求类型
typedef enum : NSUInteger {
    CPNetHttp_POST,
    CPNetHttp_GET,
    CPNetHttp_DEL,
    CPNetHttp_PUT,
    CPNetHttp_PATCH
} CPNetHttp_Type;


@interface CPNetRequest ()
@property (nonatomic , strong) NSArray<NSString *> *jsonAdjusts;
@end

@implementation CPNetRequest

//单列属性
static CPNetRequest * cpManager;
static AFURLSessionManager *cpURLSessionManager;

+(CPNetRequest *)getManager
{
    @synchronized (self)
    {
        if (!cpManager)
        {
            cpManager = [[CPNetRequest alloc] init];
            cpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"charset=utf-8",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/plain", nil];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            cpURLSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        }
    }
    return cpManager;
}


/******************************************************************
 普通网络请求
 ******************************************************************/
- (NSURLSessionDataTask *)CPPOST:(NSString *)urlStr
                      parameters:(NSDictionary *)dictionary
                         success:(CPNetRequestSuccess)success
                         failure:(CPNetRequestFailure)failure
{
    
    return [self request:urlStr
              parameters:dictionary
                httpType:CPNetHttp_POST
                 success:success
                 failure:failure];
}

- (NSURLSessionDataTask *)CPGET:(NSString *)urlStr
                     parameters:(NSDictionary *)dictionary
                        success:(CPNetRequestSuccess)success
                        failure:(CPNetRequestFailure)failure
{
    
    return [self request:urlStr
              parameters:dictionary
                httpType:CPNetHttp_GET
                 success:success
                 failure:failure];
}

- (NSURLSessionDataTask *)CPPUT:(NSString *)urlStr
                     parameters:(NSDictionary *)dictionary
                        success:(CPNetRequestSuccess)success
                        failure:(CPNetRequestFailure)failure
{
    
    return [self request:urlStr
              parameters:dictionary
                httpType:CPNetHttp_PUT
                 success:success
                 failure:failure];
}

- (NSURLSessionDataTask *)CPPATCH:(NSString *)urlStr
                       parameters:(NSDictionary *)dictionary
                          success:(CPNetRequestSuccess)success
                          failure:(CPNetRequestFailure)failure
{
    
    return [self request:urlStr
              parameters:dictionary
                httpType:CPNetHttp_PATCH
                 success:success
                 failure:failure];
}

- (NSURLSessionDataTask *)CPDEL:(NSString *)urlStr
                     parameters:(NSDictionary *)dictionary
                        success:(CPNetRequestSuccess)success
                        failure:(CPNetRequestFailure)failure
{
    
    return [self request:urlStr
              parameters:dictionary
                httpType:CPNetHttp_DEL
                 success:success
                 failure:failure];
}


- (NSURLSessionDataTask *)request:(NSString *)urlStr
                       parameters:(NSDictionary *)dictionary
                         httpType:(CPNetHttp_Type)type
                          success:(CPNetRequestSuccess)success
                          failure:(CPNetRequestFailure)failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    [self addRequestSerializerHead:urlStr];
    NSURLSessionDataTask *task;
    __weak CPNetRequest *weakSelf = self;
    if (type == CPNetHttp_GET)
    {
        task = [cpManager GET:urlStr parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            if ([responseObject[@"code"] integerValue] == -1)
            {
                NSLog(@"%@出错",urlStr);
            }
            else if ([responseObject[@"code"] integerValue] == -2)
            {
                NSLog(@"token出错：%@",urlStr);
                NSLog(@"responseObject:%@",responseObject);
            }
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf failObject:error  task:task failure:failure];
        }];
    }
    else if (type == CPNetHttp_POST)
    {
        task = [cpManager POST:urlStr parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            if ([responseObject[@"code"] integerValue] == -1)
            {
                NSLog(@"%@出错",urlStr);
            }
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf failObject:error task:task failure:failure];
        }];
    }
    else if (type == CPNetHttp_DEL)
    {
        task = [cpManager DELETE:urlStr parameters:dictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf failObject:error task:task failure:failure];
        }];
    }
    else if (type == CPNetHttp_PUT)
    {
        task = [cpManager PUT:urlStr parameters:dictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf failObject:error task:task failure:failure];
        }];
    }
    else if (type == CPNetHttp_PATCH)
    {
        task = [cpManager PATCH:urlStr parameters:dictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf failObject:error task:task failure:failure];
        }];
    }
    return task;
}


/******************************************************************
 文件上传
 ******************************************************************/

- (NSURLSessionDataTask *)CPPOST:(NSString *)urlStr
                      parameters:(NSDictionary *)dictionary
                      dataModels:(NSArray<CPDataModel *> *)dataModels
                        progress:(CPNetRequestDownProgress)progress
                         success:(CPNetRequestSuccess)success
                         failure:(CPNetRequestFailure)failure
{
    
    return [self manager:cpManager
                     url:urlStr
              parameters:dictionary
              dataModels:dataModels
                progress:progress
                 success:success
                 failure:failure];
}

- (NSURLSessionDataTask *)manager:(AFHTTPSessionManager *)manager
                              url:(NSString *)urlStr
                       parameters:(NSDictionary *)dictionary
                       dataModels:(NSArray<CPDataModel *> *)dataModels
                         progress:(CPNetRequestDownProgress)progress
                          success:(CPNetRequestSuccess)success
                          failure:(CPNetRequestFailure)failure
{
    __weak CPNetRequest *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    [self addRequestSerializerHead:urlStr];
    NSURLSessionDataTask *task = nil;
    task = [manager POST:urlStr parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
            {
                for (CPDataModel *dataModel in dataModels)
                {
                    //图片上传
                    if (dataModel.type == CPDataModelUpload_Image)
                    {
                        [formData appendPartWithFileData:dataModel.image_data name:dataModel.image_name fileName:dataModel.image_fileName mimeType:dataModel.image_mimeType];
                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progress)
                    {
                        progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    }
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                __strong CPNetRequest *strongSelf = weakSelf;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [strongSelf responseObject:responseObject task:task success:success failure:failure];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
            {
                __strong CPNetRequest *strongSelf = weakSelf;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [strongSelf failObject:error task:task failure:failure];
            }];
    return task;
}


/******************************************************************
 文件下载
 ******************************************************************/
- (NSURLSessionDownloadTask *)CPdownloadUrl:(NSString *)urlStr
                                   progress:(CPNetRequestDownProgress)progress
                                destination:(CPNetRequestDestination)destination
                          completionHandler:(CPNetRequestDownCompletionHandler)completionHandler
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSessionDownloadTask *downloadTask = [cpURLSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress)
            {
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        });
    } destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (completionHandler)
        {
            completionHandler(response,filePath,error);
        }
        
    }];
    return downloadTask;
}


#pragma mark - Method
//添加请求头
- (void)addRequestSerializerHead:(NSString *)urlStr
{
    
    //表单
    if (![self isJson:urlStr])
    {
        cpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    //json
    else {
        cpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    [cpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    cpManager.requestSerializer.timeoutInterval = 30.f;
    [cpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
}

//正在加载中失败
- (void) failObject:(NSError *)error
               task:(NSURLSessionDataTask * _Nonnull)task
            failure:(CPNetRequestFailure)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"网络异常  -----  code:%ld",error.code);
    if (failure) failure(@"网络异常",[NSString stringWithFormat:@"%ld",(long)error.code],task);
}


//请求结果数据处理
- (void)responseObject:(id  _Nullable)responseObject
                  task:(NSURLSessionDataTask * _Nonnull)task
               success:(CPNetRequestSuccess)success
               failure:(CPNetRequestFailure)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSLog(@"%@",responseObject)
    if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"] &&
        responseObject != nil)
    {
        if (success)
        {
            success(responseObject,task);
        }
    }
    else
    {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"-2"])
        {
//            [[CPAppSingle shareManager].acountServer.tokenErrorCommand execute:nil];
        }
        
        if (failure)
        {
            NSString *message = responseObject[@"message"];
            failure(message,responseObject[@"code"],task);
        }
    }
}

//判断请求类是否需要转json格式
- (BOOL)isJson:(NSString *)urlStr{
    for (NSString *str in self.jsonAdjusts)
    {
        if ([urlStr containsString:str])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - get
- (NSArray<NSString *> *)jsonAdjusts{
    if (_jsonAdjusts == nil)
    {
        _jsonAdjusts = @[];
    }
    return _jsonAdjusts;
}

@end

