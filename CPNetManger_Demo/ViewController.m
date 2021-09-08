//
//  ViewController.m
//  CPNetManger_Demo
//
//  Created by 陈平 on 2019/11/4.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "ViewController.h"
#import "CPNetManager.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CPNetDownFileCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray<NSString *> *urls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urls = @[@"http://mvvideo10.meitudata.com/5b3604ff1083a5568_H264_4_2581bc06aff3ca.mp4",
                  @"https://mvvideo10.meitudata.com/5fb3a7f0139b0j1v8asvcb3489_H264_4_43f2d991f0cd12.mp4",
                  @"https://mvvideo10.meitudata.com/5fb26636edd76zaclbvlk84506_H264_4_43a7d5e9bc4fac.mp4",
                  @"https://mvvideo10.meitudata.com/5fafacc3423576v67d0iov4987_H264_4_4305932e48402a.mp4",
                  @"https://mvvideo10.meitudata.com/5fae593042128orqicgyck6627_H264_4_42b73aec80bf16.mp4",];
    
    NSLog(@"%@",NSHomeDirectory());
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
      
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部停止" style:UIBarButtonItemStyleDone target:self action:@selector(stop)];
    
    
    
}
 

- (void)stop{
    [CPNetManager stopAllDownTask];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.urls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPNetDownFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CPNetDownFileCell.class)];
    cell.url = self.urls[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.bounds.size.width tableView:tableView];
}



-(UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[CPNetDownFileCell class] forCellReuseIdentifier:NSStringFromClass(CPNetDownFileCell.class)];
    }
    return _tableView;
}

@end
