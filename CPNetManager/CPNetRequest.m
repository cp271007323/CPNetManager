//
//  CPNetRequest.m
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import "CPNetRequest.h"
#import "RACCommand+CPNetExtension.h"
#import "NSURLSessionDownloadTask+CPNetRequestUrl.h"

//请求类型
typedef enum : NSUInteger {
    CPNetHttp_POST,
    CPNetHttp_GET,
    CPNetHttp_DEL,
    CPNetHttp_PUT,
    CPNetHttp_PATCH
} CPNetHttp_Type;


@interface CPNetRequest ()

/// 显示日志
@property (nonatomic , assign) BOOL isShowLogs;
@property (nonatomic , assign) BOOL isAllRequestForJson;

@property (nonatomic , copy) NSString *codeKey;
@property (nonatomic , copy) NSString *messageKey;

/// json上传格式的接口
@property (nonatomic , strong) NSMutableArray<NSString *> *jsonAdjustsUrl;

/// 请求头内容
@property (nonatomic , strong) NSDictionary *headHTTPHeaderField;

/// token过期的code字段
@property (nonatomic , strong) NSMutableSet<NSString *> *tokenCodes;

/// 请求成功的标识code
@property (nonatomic , strong) NSMutableSet<NSString *> *responseObjectCodes;

/// token过期回调
@property (nonatomic , copy) CPNetRequestTokenOverdueBlock tokenOverdueBlock;

/// 请求任务数组
@property (nonatomic , strong) NSMutableArray<RACCommand *> *commandArr;
/// 下载任务数组
@property (nonatomic , strong) NSMutableArray<NSURLSessionDownloadTask *> *downTaskArr;

/// 下载文件记录
@property (nonatomic , strong) NSMutableDictionary<NSString * , NSData *> *downFileDataSource;

/// 错误编码回调字段
@property (nonatomic , strong) NSMutableDictionary<NSString *, CPNetRequestFailure> *errorCodeDictionary;
@end

@implementation CPNetRequest

//单列属性
static CPNetRequest * cpManager;
static AFURLSessionManager *cpURLSessionManager;

#pragma mark - Publick
+(CPNetRequest *)getManager
{
    @synchronized (self) {
        if (!cpManager) {
            cpManager = [[CPNetRequest alloc] init];
            cpManager.codeKey = @"code";
            cpManager.messageKey = @"message";
            cpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"charset=utf-8",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/plain", nil];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"CPNetDownFile"];

            cpURLSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        }
    }
    return cpManager;
}

- (void)addHeadHTTPHeaderField:(NSDictionary *_Nullable)dic
{
    self.headHTTPHeaderField = dic;
    [self.headHTTPHeaderField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cpManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (void)showLogs
{
    self.isShowLogs = YES;
}

- (void)changeCodeForNewCodeKey:(NSString * _Nonnull)codeKey
{
    self.codeKey = codeKey;
}
 
- (void)changeMessageForNewMessageKey:(NSString * _Nonnull)messageKey
{
    self.messageKey = messageKey;
}

- (void)addResponseObjectCodes:(NSArray<NSString *> * _Nonnull)codes
{
    [self.responseObjectCodes removeAllObjects];
    [self.responseObjectCodes addObjectsFromArray:codes];
}

- (void)addRequestJsonUrl:(NSString *_Nonnull)url
{
    [self.jsonAdjustsUrl addObject:url];
}

- (void)allRequestForJson
{
    self.isAllRequestForJson = YES;
}

- (void)addTokenCodes:(NSArray<NSString *> *_Nonnull)tokenCodes tokenOverdue:(CPNetRequestTokenOverdueBlock _Nullable)tokenOverdueBlock;
{
    [self.tokenCodes addObjectsFromArray:tokenCodes];
    self.tokenOverdueBlock = tokenOverdueBlock;
}

- (void)addErrorCode:(NSString *_Nonnull)errorCode backBack:(CPNetRequestFailure _Nullable)backBack
{
    if (backBack) {
        [self.errorCodeDictionary addEntriesFromDictionary:@{errorCode : backBack}];
    }
}

- (void)addCommandTask:(RACCommand *_Nonnull)command;
{
    //判断是否已经存在，不存在就添加
    if (![self.commandArr containsObject:command]) {
        if (command) {
            [self.commandArr addObject:command];
        }
    }
    if (self.isShowLogs)
        NSLog(@"addCommandTask:%@\n%@",self.commandArr,[[self.commandArr valueForKey:@"task"] valueForKey:@"originalRequest"]);
}

- (void)removeCommandTask:(RACCommand *)command
{
    //判断是否已经存在，存在就移除
    if ([self.commandArr containsObject:command]) {
       [self.commandArr removeObject:command];
    }
    if (self.isShowLogs)
        NSLog(@"removeCommandTask:%@\n%@",self.commandArr,[[self.commandArr valueForKey:@"task"] valueForKey:@"originalRequest"]);
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
    [self adjustRequestSerializerHead:urlStr];
    NSURLSessionDataTask *task;
    __weak CPNetRequest *weakSelf = self;
    
    if (type == CPNetHttp_GET) {
        task = [cpManager GET:urlStr parameters:dictionary headers:self.headHTTPHeaderField progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            if (error.code == -1001) {
                [strongSelf request:urlStr parameters:dictionary httpType:type success:success failure:failure];
            }
            else {
                [strongSelf failObject:error task:task failure:failure];
            }
        }];
    }
    else if (type == CPNetHttp_POST) {
        task = [cpManager POST:urlStr parameters:dictionary headers:self.headHTTPHeaderField progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            if (error.code == -1001) {
                [strongSelf request:urlStr parameters:dictionary httpType:type success:success failure:failure];
            }
            else {
                [strongSelf failObject:error task:task failure:failure];
            }
        }];
    }
    else if (type == CPNetHttp_DEL) {
        task = [cpManager DELETE:urlStr parameters:dictionary headers:self.headHTTPHeaderField success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            if (error.code == -1001) {
                [strongSelf request:urlStr parameters:dictionary httpType:type success:success failure:failure];
            }
            else {
                [strongSelf failObject:error task:task failure:failure];
            }
        }];
    }
    else if (type == CPNetHttp_PUT) {
        task = [cpManager PUT:urlStr parameters:dictionary headers:self.headHTTPHeaderField success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            if (error.code == -1001) {
                [strongSelf request:urlStr parameters:dictionary httpType:type success:success failure:failure];
            }
            else {
                [strongSelf failObject:error task:task failure:failure];
            }
        }];
    }
    else if (type == CPNetHttp_PATCH) {
        task = [cpManager PATCH:urlStr parameters:dictionary headers:self.headHTTPHeaderField success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            __strong CPNetRequest *strongSelf = weakSelf;
            [strongSelf responseObject:responseObject task:task success:success failure:failure];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            __strong CPNetRequest *strongSelf = weakSelf;
            if (error.code == -1001) {
                [strongSelf request:urlStr parameters:dictionary httpType:type success:success failure:failure];
            }
            else {
                [strongSelf failObject:error task:task failure:failure];
            }
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
    [self adjustRequestSerializerHead:urlStr];
    NSURLSessionDataTask *task = nil;
    task = [manager POST:urlStr parameters:dictionary headers:self.headHTTPHeaderField constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (CPDataModel *dataModel in dataModels) {
            //图片上传
            if (dataModel.type == CPDataModelUpload_Image) {
                [formData appendPartWithFileData:dataModel.image_data name:dataModel.image_name fileName:dataModel.image_fileName mimeType:dataModel.image_mimeType];
            }
            //视频上传
            else if (dataModel.type == CPDataModelUpload_Video) {
                [formData appendPartWithFileData:dataModel.video_data name:dataModel.video_Name fileName:dataModel.video_fileName mimeType:dataModel.video_mimeType];
                [formData appendPartWithFileData:dataModel.video_thumb_data name:dataModel.video_thumb_name fileName:dataModel.video_thumb_fileName mimeType:dataModel.video_thumb_mimeType];
            }
            //语音上传
            else if (dataModel.type == CPDataModelUpload_Audio) {
                [formData appendPartWithFileData:dataModel.audio_data name:dataModel.audio_name fileName:dataModel.audio_fileName mimeType:dataModel.audio_mimeType];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong CPNetRequest *strongSelf = weakSelf;
        [strongSelf responseObject:responseObject task:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong CPNetRequest *strongSelf = weakSelf;
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
    [self adjustRequestSerializerHead:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    __weak CPNetRequest *weakSelf = self;
    if ([self.downFileDataSource.allKeys containsObject:urlStr.lastPathComponent]) {
        NSURLSessionDownloadTask *downloadTask = [cpURLSessionManager downloadTaskWithResumeData:self.downFileDataSource[urlStr.lastPathComponent] progress:^(NSProgress * _Nonnull downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progress) {
                    progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                }
            });
        } destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error){
            if (!error) {
                __strong CPNetRequest *strongSelf = weakSelf;
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.CPNetRequestUrl contains %@",urlStr.lastPathComponent];
                [strongSelf.downTaskArr removeObjectsInArray:[strongSelf.downTaskArr filteredArrayUsingPredicate:pre]];
                [strongSelf.downFileDataSource removeObjectForKey:filePath.absoluteString.lastPathComponent];
                [strongSelf updataDownFileDataSourceToLocation];
            }
            if (completionHandler) {
                completionHandler(response,filePath,error);
            }
        }];
        downloadTask.CPNetRequestUrl = urlStr;
        [self.downTaskArr addObject:downloadTask];
        return downloadTask;
    }
    else {
        NSURLSessionDownloadTask *downloadTask = [cpURLSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progress) {
                    progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                }
            });
        } destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error){
            if (!error) {
                __strong CPNetRequest *strongSelf = weakSelf;
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.CPNetRequestUrl contains %@",urlStr.lastPathComponent];
                [strongSelf.downTaskArr removeObjectsInArray:[strongSelf.downTaskArr filteredArrayUsingPredicate:pre]];
                [strongSelf.downFileDataSource removeObjectForKey:filePath.absoluteString.lastPathComponent];
                [strongSelf updataDownFileDataSourceToLocation];
            }
            if (completionHandler) {
                completionHandler(response,filePath,error);
            }
        }];
        downloadTask.CPNetRequestUrl = urlStr;
        [self.downTaskArr addObject:downloadTask];
        return downloadTask;
    }
}

- (void)stopAllDownFileTask
{
    __weak CPNetRequest *weakSelf = self;
    [self.downTaskArr enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == NSURLSessionTaskStateRunning) {
            [obj cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                __strong CPNetRequest *strongSelf = weakSelf;
                [strongSelf.downFileDataSource setValue:resumeData forKey:[NSString stringWithFormat:@"%@",obj.CPNetRequestUrl.lastPathComponent]];
            }];
        }
    }];
    [self.downTaskArr removeAllObjects];
    [self updataDownFileDataSourceToLocation];
}

- (void)stopDownFileTask:(NSURLSessionDownloadTask *)task
{
    if (!task) return;
    
    if (task.state == NSURLSessionTaskStateRunning) {
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            [self.downFileDataSource setValue:resumeData forKey:task.CPNetRequestUrl.lastPathComponent];
        }];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.CPNetRequestUrl contains %@",self.CPNetRequestUrl.lastPathComponent];
        [self.downTaskArr removeObjectsInArray:[self.downTaskArr filteredArrayUsingPredicate:pre]];
    }
}

#pragma mark - Method
//添加请求头
- (void)adjustRequestSerializerHead:(NSString *)urlStr
{
    //表单
    if (![self isJson:urlStr]) {
        cpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    //json
    else {
        cpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    [self.headHTTPHeaderField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cpManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [cpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    cpManager.requestSerializer.timeoutInterval = 10.f;
    [cpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

//正在加载中失败
- (void) failObject:(NSError *)error
               task:(NSURLSessionDataTask * _Nonnull)task
            failure:(CPNetRequestFailure)failure
{
    if (self.isShowLogs) NSLog(@"网络异常  -----  code:%ld   %@",error.code,error.description);
    if (failure) failure(nil,[NSString stringWithFormat:@"%@",error.description],[NSString stringWithFormat:@"%ld",(long)error.code],task);
}


//请求结果数据处理
- (void)responseObject:(id  _Nullable)responseObject
                  task:(NSURLSessionDataTask * _Nonnull)task
               success:(CPNetRequestSuccess)success
               failure:(CPNetRequestFailure)failure
{
    NSString *code = [NSString stringWithFormat:@"%@",responseObject[self.codeKey]];
    
    if ([self.responseObjectCodes containsObject:code] &&
        responseObject != nil) {
        if (success) {
            //移除成功的请求
            success(responseObject,task);
        }
    }
    else {
        //比较tokenCode
        if ([self.tokenCodes containsObject:code]) {
            static BOOL flag = NO;
            //取消所有任务
            [self stopAllDataTaskRequest];
            
            //防止多次进入换取新token
            if (flag == NO) {
                flag = YES;
                //token回调过期处理,获取新token
                if (self.tokenOverdueBlock) {
                    self.tokenOverdueBlock(&flag);
                }
            }
        }
        
        if ([self.errorCodeDictionary.allKeys containsObject:code] && self.errorCodeDictionary[code]) {
            NSString *message = responseObject[self.messageKey];
            self.errorCodeDictionary[code](responseObject,message,responseObject[self.codeKey],task);
        }
        
        if (failure) {
            NSString *message = responseObject[self.messageKey];
            failure(responseObject,message,responseObject[self.codeKey],task);
        }
    }
}

//判断请求类是否需要转json格式
- (BOOL)isJson:(NSString *)urlStr
{
    if (self.isAllRequestForJson) return YES;
    
    for (NSString *str in self.jsonAdjustsUrl) {
        if ([urlStr containsString:str]) {
            return YES;
        }
    }
    return NO;
}

//开始/恢复请求
- (void)startAllDataTaskRequest
{
    for (RACCommand *command in self.commandArr) {
        [command execute:command.netExtension];
    }
}

//暂停任务
- (void)stopAllDataTaskRequest
{
    [self.commandArr enumerateObjectsUsingBlock:^(RACCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.task suspend];
    }];
}

//取消任务
- (void)cancelAllDataTaskRequest
{
    [self.commandArr enumerateObjectsUsingBlock:^(RACCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.task cancel];
    }];
    [self.commandArr removeAllObjects];
}

- (void)updataDownFileDataSourceToLocation
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"downRecordDataSource"];
    [self.downFileDataSource writeToFile:path atomically:NO];
}

#pragma mark - get
- (NSMutableArray<NSString *> *)jsonAdjustsUrl
{
    if (_jsonAdjustsUrl == nil) {
        _jsonAdjustsUrl = [NSMutableArray array];
    }
    return _jsonAdjustsUrl;
}

- (NSMutableArray<RACCommand *> *)commandArr
{
    if (_commandArr == nil) {
        _commandArr = [NSMutableArray array];
    }
    return _commandArr;
}

- (NSMutableArray<NSURLSessionDownloadTask *> *)downTaskArr
{
    if (_downTaskArr == nil) {
        _downTaskArr = [NSMutableArray array];
    }
    return _downTaskArr;
}

- (NSMutableDictionary<NSString *,NSData *> *)downFileDataSource
{
    if (_downFileDataSource == nil) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"downRecordDataSource"];
        _downFileDataSource = [NSDictionary dictionaryWithContentsOfFile:path].mutableCopy;
        if (_downFileDataSource == nil) {
            _downFileDataSource = [NSMutableDictionary dictionary];
        }
    }
    return _downFileDataSource;
}

- (NSMutableSet<NSString *> *)responseObjectCodes
{
    if (_responseObjectCodes == nil) {
        _responseObjectCodes = [NSMutableSet set];
        [_responseObjectCodes addObject:@"1"];
    }
    return _responseObjectCodes;
}

- (NSMutableSet<NSString *> *)tokenCodes
{
    if (_tokenCodes == nil) {
        _tokenCodes = [NSMutableSet set];
    }
    return _tokenCodes;
}

- (NSMutableDictionary<NSString *,CPNetRequestFailure> *)errorCodeDictionary
{
    if (_errorCodeDictionary == nil) {
        _errorCodeDictionary = [NSMutableDictionary dictionary];
    }
    return _errorCodeDictionary;
}


@end
