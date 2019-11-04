//
//  CPDataModel.m
//  网络请求
//
//  Created by chenp on 17/3/30.
//  Copyright © 2017年 CPJY. All rights reserved.
//

#import "CPDataModel.h"
#import <AVFoundation/AVFoundation.h>

//static NSString *upload_Image = @"image/png";
static NSString *upload_Image = @"multipart/form-data";

#define CPDataModelTimeIntervalSince1970 [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)]

@implementation CPDataModel

- (void)setType:(CPDataModelUpload_Type)type
{
    _type = type;
    if (type == CPDataModelUpload_Image)
        {
        self.image_type = _type;
    }
}

- (void)setImage_type:(CPDataModelUpload_Type)image_type
{
    _image_type = image_type;
    self.image_mimeType = upload_Image;
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

@end
