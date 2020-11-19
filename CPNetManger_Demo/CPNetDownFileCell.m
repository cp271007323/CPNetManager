//
//  CPNetDownFileCell.m
//  CPNetManger_Demo
//
//  Created by Mac on 2020/11/19.
//  Copyright © 2020 MAC. All rights reserved.
//

#import "CPNetDownFileCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "CPNetManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation CPNetDownFileCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView sd_addSubviews:@[self.progressView,self.startBtn,self.stopBtn]];
        
        self.progressView.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 20)
        .leftSpaceToView(self.contentView, 40)
        .rightSpaceToView(self.contentView, 40)
        .heightIs(40);

        self.startBtn.sd_layout
        .topSpaceToView(self.progressView, 30)
        .leftSpaceToView(self.contentView, 30)
        .widthIs(60)
        .heightIs(40);

        self.stopBtn.sd_layout
        .topSpaceToView(self.progressView, 30)
        .rightSpaceToView(self.contentView, 30)
        .widthIs(60)
        .heightIs(40);
        
        [self setupAutoHeightWithBottomView:self.startBtn bottomMargin:20];
        
        [[self.startBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.task.state != NSURLSessionTaskStateRunning || !self.task) {
                self.task = [CPNetManager downloadUrl:self.url progress:^(CGFloat uploadProgress) {
                    self.progressView.progress = uploadProgress;
//                    NSLog(@"uploadProgress:%lf",uploadProgress);
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *toPath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.url.lastPathComponent];
                    return [NSURL fileURLWithPath:toPath];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                    NSLog(@"%@  %@   %@",response,filePath,error);
                }];
                [self.task resume];
            }
        }];

        [[self.stopBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [CPNetRequest.getManager stopDownFileTask:self.task];
        }];
    }
    return self;
}

- (UIButton *)startBtn
{
    if (_startBtn == nil) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_startBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    }
    return _startBtn;
}

- (UIButton *)stopBtn
{
    if (_stopBtn == nil) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_stopBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    }
    return _stopBtn;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    }
    return _progressView;
}

@end
