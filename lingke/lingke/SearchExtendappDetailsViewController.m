//
//  SearchExtendappDetailsViewController.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendappDetailsViewController.h"
#import "AppurikindTableViewCell.h"
#import "SearchDataindexModel.h"
#import "DataIndexViewController.h"

@interface SearchExtendappDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SearchExtendappDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self hiddenSurplusLine:self.tableView];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)leftButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppurikindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppurikindTableViewCell"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"AppurikindTableViewCell" owner:self options:nil].lastObject;
    }
    
    SearchDataindexModel *searchDataindexModel = self.searchDataArray[indexPath.row];
    
    cell.titleLabel.text = searchDataindexModel.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    SearchDataindexModel *searchDataindexModel = self.searchDataArray[indexPath.row];
    
    DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
    
    dataIndexViewController.title = searchDataindexModel.title;
    
    dataIndexViewController.url = searchDataindexModel.openurl;
    
    [self.navigationController pushViewController:dataIndexViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
