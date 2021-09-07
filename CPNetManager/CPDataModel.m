//
//  CPDataModel.m
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import "CPDataModel.h"
#import <AVFoundation/AVFoundation.h>

static NSString *upload_Image = @"multipart/form-data";
static NSString *upload_Audio = @"amr";
static NSString *upload_Video = @"mp4";


#define CPDataModelTimeIntervalSince1970 [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)]

@implementation CPDataModel

- (void)setType:(CPDataModelUpload_Type)type
{
    _type = type;
    if (type == CPDataModelUpload_Image) {
        self.image_type = _type;
    }else if (type == CPDataModelUpload_Video){
        self.video_type = _type;
    }else if (type == CPDataModelUpload_Audio){
        self.audio_type = _type;
    }
}

- (void)setImage_type:(CPDataModelUpload_Type)image_type
{
    _image_type = image_type;
    self.image_mimeType = upload_Image;
}

-(void)setVideo_type:(CPDataModelUpload_Type)video_type{
    _video_type = video_type;
    self.video_mimeType = upload_Video;
    self.video_thumb_mimeType = upload_Image;
}

-(void)setAudio_type:(CPDataModelUpload_Type)audio_type{
    _audio_type = audio_type;
    self.audio_mimeType = upload_Audio;
}

- (void)setDataModelWithImage:(UIImage * _Nonnull)image
                        type:(CPDataModelUpload_Type)type
                    fileName:(NSString * _Nonnull)fileName
{
    self.type = type;
    self.image_data = UIImageJPEGRepresentation(image, 1);
    if (self.image_data.length > 600000)
        {
        self.image_data = UIImageJPEGRepresentation(image, 0.6);
    }
    NSString *timeStr = CPDataModelTimeIntervalSince1970;
    self.image_name = [NSString stringWithFormat:@"%@",fileName];
    self.image_fileName = [NSString stringWithFormat:@"%@_%@.png",fileName,timeStr];
}

-(void)setDataModelWithVideoPath:(NSString * _Nonnull)videoPath
                            type:(CPDataModelUpload_Type)type
                        fileName:(NSString * _Nonnull)fileName{
    self.type = type;
    self.video_path = videoPath;
    self.video_data = [NSData dataWithContentsOfFile:videoPath];
    self.video_thumb_data = UIImageJPEGRepresentation([self videoToImg:[NSURL fileURLWithPath:videoPath]], .7);
    NSString *timeStr = CPDataModelTimeIntervalSince1970;
    self.video_Name = [NSString stringWithFormat:@"%@_%@",fileName,timeStr];
    self.video_thumb_name = [NSString stringWithFormat:@"%@_%@_s",fileName,timeStr];
    self.video_fileName = [NSString stringWithFormat:@"%@_%@.mp4",fileName,timeStr];
    self.video_thumb_fileName = [NSString stringWithFormat:@"%@_%@_s.png",fileName,timeStr];
}

-(void)setDataModelWithAudioPath:(NSString * _Nonnull)AudioPath
                            type:(CPDataModelUpload_Type)type
                        fileName:(NSString * _Nonnull)fileName{
    self.type = type;
    self.audio_path = AudioPath;
    self.audio_data = [NSData dataWithContentsOfFile:AudioPath];
    NSString *timeStr = CPDataModelTimeIntervalSince1970;
    self.audio_fileName = [NSString stringWithFormat:@"%@_%@.amr",fileName,timeStr];
    self.audio_name = [NSString stringWithFormat:@"%@_%@",fileName,timeStr];
}

-(UIImage *)videoToImg:(NSURL *)videoUrl{
    //截取图片
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(0.1, 700);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    return image;
}

@end
