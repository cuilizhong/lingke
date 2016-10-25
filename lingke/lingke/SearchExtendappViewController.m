//
//  SearchExtendappViewController.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendappViewController.h"
#import "SearchExtendappCell.h"
#import "SearchfieldModel.h"
#import "GDataXMLNode.h"
#import "SearchDataindexModel.h"
#import "SearchExtendappDetailsViewController.h"
#import "SearchExtendAppSubViewController.h"


@interface SearchExtendappViewController ()

@property(nonatomic,strong)SearchExtendAppSubViewController *searchExtendAppSubViewController;


@end

@implementation SearchExtendappViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"搜索";
    
    self.searchExtendAppSubViewController = [[SearchExtendAppSubViewController alloc]init];
    self.searchExtendAppSubViewController.appmenuModel = self.appmenuModel;
    self.searchExtendAppSubViewController.extendappModel = self.extendappModel;
    [self addChildViewController:self.searchExtendAppSubViewController];
    [self.view addSubview:self.searchExtendAppSubViewController.view];
    self.searchExtendAppSubViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *startSearchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"开始搜索" style:UIBarButtonItemStylePlain target:self action:@selector(startSearchAction:)];
    self.navigationItem.rightBarButtonItem = startSearchBarButton;
}

- (void)leftButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startSearchAction:(UIBarButtonItem *)sender{
    
    [self.view endEditing:YES];
    
    if (self.searchExtendAppSubViewController.dataArray.count<1) {
        
        [self hiddenHUDWithMessage:@"暂无查询条件"];
        
        return;
    }
    
    SearchExtendappDetailsViewController *searchExtendappDetailsViewController = [[SearchExtendappDetailsViewController alloc]init];
    
    searchExtendappDetailsViewController.dataArray = self.searchExtendAppSubViewController.dataArray;
    
    searchExtendappDetailsViewController.appmenuModel = self.appmenuModel;
    
    searchExtendappDetailsViewController.extendappModel = self.extendappModel;
    
    [self.navigationController pushViewController:searchExtendappDetailsViewController animated:NO];
}

@end
