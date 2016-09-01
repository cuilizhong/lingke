//
//  MailListClassViewController.m
//  lingke
//
//  Created by clz on 16/9/1.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MailListClassViewController.h"

@interface MailListClassViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UISearchBar *searchBar;

@end

@implementation MailListClassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.searchBar.delegate = self;
    [self.searchBar showsCancelButton];
    self.searchBar.placeholder=@"Search";

    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.searchBar.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - self.searchBar.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark-UISearchBarDelegate
//任务编辑文本
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}

//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

//当点击search的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
}




#pragma mark-UITableViewDelegate,UITableViewDataSource

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
