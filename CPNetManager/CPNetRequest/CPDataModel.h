//
//  CPDataModel.h
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//文件上传类型
typedef enum : NSUInteger {
    CPDataModelUpload_Image,
    CPDataModelUpload_Video,
    CPDataModelUpload_Audio,
} CPDataModelUpload_Type;

@interface CPDataModel : NSObject

@property(assign, nonatomic)    CPDataModelUpload_Type   type;              //文件类型

//图片
@property(assign, nonatomic)    CPDataModelUpload_Type   image_type;
@property(strong, nonatomic)    NSData                  * _Null_unspecified image_data;
@property(strong, nonatomic)    NSData                  * _Null_unspecified image_thumb_data;
@property(copy, nonatomic)      NSString                * _Null_unspecified image_name;
@property(copy, nonatomic)      NSString                * _Null_unspecified image_thumb_name;
@property(copy, nonatomic)      NSString                * _Null_unspecified image_fileName;
@property(copy, nonatomic)      NSString                * _Null_unspecified image_thumb_fileName;
@property(copy, nonatomic)      NSString                * _Null_unspecified image_mimeType;

- (void)setDataModelWithImage:(UIImage * _Nonnull)image
                         type:(CPDataModelUpload_Type)type
                     fileName:(NSString * _Nonnull)fileName;


//视频
@property(assign, nonatomic)    CPDataModelUpload_Type   video_type;
@property(assign, nonatomic)    CPDataModelUpload_Type   video_Thumb_type;
@property(strong, nonatomic)    NSString                * _Null_unspecified video_path;
@property(strong, nonatomic)    NSData                  * _Null_unspecified video_data;
@property(strong, nonatomic)    NSData                  * _Null_unspecified video_thumb_data;
@property(copy, nonatomic)      NSString                * _Null_unspecified video_Name;
@property(copy, nonatomic)      NSString                * _Null_unspecified video_thumb_name;
@property(copy, nonatomic)      NSString                * _Null_unspecified video_fileName;
@property(copy, nonatomic)      NSString                * _Null_unspecified video_thumb_fileName;
@property(copy, nonatomic)      NSString                * _Null_unspecified video_mimeType;
@property(copy, nonatomic)      NSString                * _Null_unspecified video_thumb_mimeType;

-(void)setDataModelWithVideoPath:(NSString * _Nonnull)videoPath type:(CPDataModelUpload_Type)type fileName:(NSString * _Nonnull)fileName;

//语音
@property(assign, nonatomic)    CPDataModelUpload_Type   audio_type;
@property(strong, nonatomic)    NSString                * _Null_unspecified audio_path;
@property(strong, nonatomic)    NSData                  * _Null_unspecified audio_data;
@property(copy, nonatomic)      NSString                * _Null_unspecified audio_name;
@property(copy, nonatomic)      NSString                * _Null_unspecified audio_fileName;
@property(copy, nonatomic)      NSString                * _Null_unspecified audio_mimeType;

-(void)setDataModelWithAudioPath:(NSString * _Nonnull)AudioPath type:(CPDataModelUpload_Type)type fileName:(NSString * _Nonnull)fileName;

@end
