//
//  AttachmentViewController.m
//  lingke
//
//  Created by clz on 16/10/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "AttachmentViewController.h"
#import "AppDelegate.h"
#import "PreviewFileViewController.h"


@interface AttachmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel *tipNoDataLabel;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"附件";
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    self.dataArray = [delegate selectAllAttachments];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self hiddenSurplusLine:self.tableView];
    
    self.tipNoDataLabel = [[UILabel alloc]init];
    self.tipNoDataLabel.text = @"暂无数据";
    self.tipNoDataLabel.font = [UIFont systemFontOfSize:14];
    self.tipNoDataLabel.textColor = [UIColor darkGrayColor];
    self.tipNoDataLabel.textAlignment = NSTextAlignmentCenter;
    self.tipNoDataLabel.backgroundColor = [UIColor clearColor];
    self.tipNoDataLabel.center = self.view.center;
    self.tipNoDataLabel.frame = CGRectMake(0,self.tipNoDataLabel.frame.origin.y-60, self.view.frame.size.width, 30);
    [self.view addSubview:self.tipNoDataLabel];
    self.tipNoDataLabel.hidden = YES;
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    NSDictionary *attachment = self.dataArray[indexPath.row];
    
    cell.textLabel.text = attachment[@"filename"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *attachment = self.dataArray[indexPath.row];
    
    NSString *filepath = attachment[@"filepath"];
    
    //查看文件
    PreviewFileViewController *previewFileViewController = [[PreviewFileViewController alloc]init];
    previewFileViewController.filepath = filepath;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:previewFileViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
