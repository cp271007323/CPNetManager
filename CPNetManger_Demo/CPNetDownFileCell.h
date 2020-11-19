//
//  CPNetDownFileCell.h
//  CPNetManger_Demo
//
//  Created by Mac on 2020/11/19.
//  Copyright © 2020 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPNetDownFileCell : UITableViewCell
@property (nonatomic , copy) NSString *url;

@property (nonatomic , strong) NSURLSessionDownloadTask *task;
@property (nonatomic , strong) UIButton *startBtn;
@property (nonatomic , strong) UIButton *stopBtn;
@property (nonatomic , strong) UIProgressView *progressView;
@end

NS_ASSUME_NONNULL_END
