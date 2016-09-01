//
//  ExtendappViewController.m
//  lingke
//
//  Created by clz on 16/8/29.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ExtendappViewController.h"
#import "ExtendappCell.h"
#import "AppurikindTableViewCell.h"
#import "MJRefresh.h"
#import "LocalData.h"
#import "ApplyViewController.h"
#import "ExtendappDetailViewController.h"

@interface ExtendappViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *menuTableView;

@property(nonatomic,strong)UITableView *contentTableView;

@property(nonatomic,strong)NSMutableArray *menusArray;

@property(nonatomic,strong)NSMutableArray *contentsArray;

//申请
@property(nonatomic,strong)AppmenuModel *applyAppmenuModel;

@end

@implementation ExtendappViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.extendappModel.appname;
    
    self.contentsArray = [[NSMutableArray alloc]init];
    
    self.menusArray = [[NSMutableArray alloc]init];
    
    [self handData];
    
    if (self.applyAppmenuModel) {
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"申请" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
        
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
    
    self.contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40,self.view.frame.size.width,self.view.frame.size.height-40-64) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
    
    self.contentTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        
        
        [self.contentTableView.mj_header endRefreshing];
        
    }];
    
    self.contentTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        
        [self.contentTableView.mj_footer endRefreshing];

    }];
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender{
    
    ApplyViewController *applyViewController = [[ApplyViewController alloc]init];
    
    applyViewController.applyAppmenuModel = self.applyAppmenuModel;
    
    applyViewController.appcode = self.extendappModel.appcode;
    
    [self.navigationController pushViewController:applyViewController animated:YES];
    
    
}

- (void)requestListDataWithAppmenuModel:(AppmenuModel*)appmenuModel{
    
    NSDictionary *dataDic = @{
                              
                              @"formid":appmenuModel.formid,
                              
                              };
    
    NSDictionary *requestNewsdata = @{
                                      
                                      @"appcode":self.extendappModel.appcode,
                                      
                                      @"method":@"LIST",
                                      
                                      @"data":dataDic
                                      
                                      };
    
    
    NSDictionary *parameters = @{
                                            
                                            @"token":[LocalData getToken],
                                            
                                            @"requestdata":requestNewsdata,
                                            
                                            };
    
    NSLog(@"appmenuModel.appuri = %@",appmenuModel.appuri);
    
    Network *listDataNetwork = [[Network alloc]initWithURL:appmenuModel.appuri parameters:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        //self.contentsArray

        
    } requestFail:^(NSError *error) {
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-20,-(self.view.frame.size.width/2.0-20-64),40,self.view.frame.size.width) style:UITableViewStylePlain];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    self.menuTableView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.menuTableView];
    
}
#pragma mark-处理数据
- (void)handData{
    
    for (AppmenuModel *appmenuModel in self.extendappModel.appmenu) {
        
        if ([appmenuModel.appurikind isEqualToString:@"APPLY"]) {
            
            self.applyAppmenuModel = appmenuModel;
            
        }else{
            
            [self.menusArray addObject:appmenuModel];

        }
    }
    
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.menuTableView) {
        
        return self.menusArray.count;
        
    }else{
        
        return self.contentsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.menuTableView) {
        
        ExtendappCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExtendappCell"];
        
        if (!cell) {
            
            cell = [[ExtendappCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExtendappCell"];
            
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }
        
        AppmenuModel *appmenuModel = self.menusArray[indexPath.row];
        
        __weak typeof(self)weakSelf = self;
        
        CGSize detailSize = [appmenuModel.appmenuname sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1000, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        
        [cell showCellWithMenuTitle:appmenuModel.appmenuname cellSize:CGSizeMake(40, detailSize.width+10) clickMenuBlock:^{
            
            [weakSelf requestListDataWithAppmenuModel:appmenuModel];
            
        }];
        
        return cell;
        
    }else{
        
        AppurikindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppurikindTableViewCell"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle]loadNibNamed:@"AppurikindTableViewCell" owner:self options:nil].lastObject;
        }
        
        cell.titleLabel.text = @"test";
        
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppmenuModel *appmenuModel = self.menusArray[indexPath.row];
    
    CGSize detailSize = [appmenuModel.appmenuname sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1000, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];

    return detailSize.width + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView  == self.contentTableView) {
        
        ExtendappDetailViewController *extendappDetailViewController = [[ExtendappDetailViewController alloc]init];
        
        self.contentsArray[indexPath.row];
        
        [self.navigationController pushViewController:extendappDetailViewController animated:YES];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
