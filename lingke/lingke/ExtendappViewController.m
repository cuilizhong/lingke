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
#import "MenusView.h"
#import "DataIndexModel.h"
#import "DataIndexViewController.h"
#import "SearchExtendappViewController.h"

static const NSInteger pagecount = 20;


@interface ExtendappViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *contentTableView;

@property(nonatomic,strong)NSMutableArray *menusArray;

@property(nonatomic,strong)NSMutableArray *contentsArray;

//申请
@property(nonatomic,strong)AppmenuModel *applyAppmenuModel;

@property(nonatomic,strong)MenusView *menusView;

@property(nonatomic,strong)AppmenuModel *currentAppmenuModel;

@property(nonatomic,strong)UIBarButtonItem *searchBarButton;

@property(nonatomic,strong)UIBarButtonItem *applyBarButton;

@property(nonatomic,strong)NSMutableArray *barButtonItems;

@property(nonatomic,assign)NSInteger pagestart;

@property(nonatomic,strong)UIWebView *webView;

//如果只有一个，那么menuHeight = 0
@property(nonatomic,assign)CGFloat menuHeight;


@end

@implementation ExtendappViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.extendappModel.appname;
    
    self.pagestart = 1;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    self.contentsArray = [[NSMutableArray alloc]init];
    
    self.menusArray = [[NSMutableArray alloc]init];
    
    self.barButtonItems = [[NSMutableArray alloc]init];
    
    [self handData];
    
    self.currentAppmenuModel = self.menusArray[0];
    
    if (self.applyAppmenuModel) {
        
        self.applyBarButton = [[UIBarButtonItem alloc]initWithTitle:@"申请" style:UIBarButtonItemStylePlain target:self action:@selector(applyBarButtonAction:)];
        
        [self.barButtonItems addObject:self.applyBarButton];
        
    }
    
    AppmenuModel *appmenuModel = self.menusArray[0];
    
    if ([appmenuModel.appurikind isEqualToString:@"HASDONE"] || [appmenuModel.appurikind isEqualToString:@"MYHASDONE"]) {
        
        self.searchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonAction:)];
        
        [self.barButtonItems addObject:self.searchBarButton];
        
    }
    
    if (self.barButtonItems.count>0) {
        
        self.navigationItem.rightBarButtonItems = self.barButtonItems;

    }
    
    
    NSMutableArray *menusTitleArray = [[NSMutableArray alloc]init];
    
    for (AppmenuModel *appmenuModel in self.menusArray) {
        
        [menusTitleArray addObject:appmenuModel.appmenuname];
    }
    
    if (self.menusArray.count>1) {
        self.menuHeight = 40.0f;
    }else{
        
        self.menuHeight = 0;
    }
    
    @weakify(self);
    self.menusView = [[MenusView  alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight) menusTitle:menusTitleArray selectedBlock:^(NSString *title) {
        
        
        weakself.pagestart = 1;

        NSLog(@"title = %@",title);
        
        //控制搜索按钮显示问题
        for (AppmenuModel *appmenuModel in weakself.menusArray) {
            
            if ([appmenuModel.appmenuname isEqualToString:title]) {
                
                //判断显示搜索按钮
                if ([appmenuModel.appurikind isEqualToString:@"HASDONE"] || [appmenuModel.appurikind isEqualToString:@"MYHASDONE"]) {
                    //已办、我的申请
                    if (![self.barButtonItems containsObject:self.searchBarButton]) {
                        
                        if (!self.searchBarButton) {
                            
                            self.searchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonAction:)];
                        }
                        
                        [self.barButtonItems addObject:self.searchBarButton];
                        
                        self.navigationItem.rightBarButtonItems = self.barButtonItems;
                    }
                    
                }else{
                    
                    if ([self.barButtonItems containsObject:self.searchBarButton]) {
                        
                        [self.barButtonItems removeObject:self.searchBarButton];
                        
                        self.navigationItem.rightBarButtonItems = self.barButtonItems;
                    }
                    
                }
                
                //请求数据
                weakself.currentAppmenuModel = appmenuModel;
                
                if (![appmenuModel.appurikind isEqualToString:@"URL"]) {
                    
                    [weakself requestListDataWithAppmenuModel:appmenuModel];

                }
                
            }
            
        }
        
        //判断是显示webview还是tableview
        for (AppmenuModel *appmenuModel in weakself.menusArray) {
            
            if ([appmenuModel.appmenuname isEqualToString:title]) {
                
                if ([appmenuModel.appurikind isEqualToString:@"URL"]) {
                    
                    weakself.contentTableView.hidden = YES;
                    weakself.webView.hidden = NO;
                    
                    NSString *token = [LocalData getToken];
                    
                        NSString *url = [NSString stringWithFormat:@"%@?token=%@",appmenuModel.appuri,token];

                    
                    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                             
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             
                                                              timeoutInterval:60];
                    
                    [self.webView loadRequest:request];
                    [self.webView scalesPageToFit];
                    
                }else{
                    
                    weakself.contentTableView.hidden = NO;
                    weakself.webView.hidden = YES;
                }
            }
            
        }


        
    }];
    [self.view addSubview:self.menusView];
    
    self.contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.menuHeight,self.view.frame.size.width,self.view.frame.size.height-self.menuHeight-64) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
    
    [self hiddenSurplusLine:self.contentTableView];
    
    
    self.contentTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        weakself.pagestart = 1;
        
        [weakself requestListDataWithAppmenuModel:weakself.currentAppmenuModel];
        
    }];
    
    self.contentTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
   
        
        weakself.pagestart = weakself.pagestart + pagecount;
        
        [weakself requestListDataWithAppmenuModel:weakself.currentAppmenuModel];

    }];
    
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = self.contentTableView.frame;
    [self.view addSubview:self.webView];
    
    //判断第一个是显示webview还是tableview
    AppmenuModel *firstAppmenuModel = self.menusArray[0];
    
    if ([firstAppmenuModel.appurikind isEqualToString:@"URL"]) {
        
        self.contentTableView.hidden = YES;
        self.webView.hidden = NO;
        
    }else{
        
        self.contentTableView.hidden = NO;
        self.webView.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self.currentAppmenuModel.appurikind isEqualToString:@"URL"]) {
        
        NSString *token = [LocalData getToken];
        
        NSString *url = [NSString stringWithFormat:@"%@?token=%@",self.currentAppmenuModel.appuri,token];
        
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                 
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                 
                                                  timeoutInterval:60];
        
        [self.webView loadRequest:request];
        [self.webView scalesPageToFit];
        
    }else{
        
        [self.contentTableView.mj_header beginRefreshing];
  
    }

}

- (void)leftButtonAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyBarButtonAction:(UIBarButtonItem *)sender{
    
    self.hidesBottomBarWhenPushed = YES;
    
    
    NSString *url = [LocalData getLoginInterface];
    
    
    url = [NSString stringWithFormat:@"%@/dataapi/applydata/%@/%@",url,self.extendappModel.appcode,self.applyAppmenuModel.formid];
    
    
    DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
    
    dataIndexViewController.title = @"申请";
    
    dataIndexViewController.url = url;
    
//    ApplyViewController *applyViewController = [[ApplyViewController alloc]init];
//    
//    applyViewController.applyAppmenuModel = self.applyAppmenuModel;
//    
//    applyViewController.appcode = self.extendappModel.appcode;
    
    [self.navigationController pushViewController:dataIndexViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;

}

- (void)searchBarButtonAction:(UIBarButtonItem *)sender{
    
    
    NSLog(@"搜索");
    
    SearchExtendappViewController *searchExtendappViewController = [[SearchExtendappViewController alloc]init];
    
    searchExtendappViewController.extendappModel = self.extendappModel;
    
    searchExtendappViewController.appmenuModel = self.currentAppmenuModel;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:searchExtendappViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)requestListDataWithAppmenuModel:(AppmenuModel*)appmenuModel{
    
    [self showHUD];
    
    NSDictionary *dataDic;
    
    if ([appmenuModel.appurikind isEqualToString:@"MYHASDONE"] || [appmenuModel.appurikind isEqualToString:@"HASDONE"]) {
        
        dataDic = @{
                    
                    @"formid":appmenuModel.formid,
                    
                    @"pagestart":[NSString stringWithFormat:@"%ld",(long)self.pagestart],
                    
                    @"pagecount":[NSString stringWithFormat:@"%ld",(long)pagecount]
                    
                    };
    }else{
        
        dataDic = @{
                    
                    @"formid":appmenuModel.formid,
                    
                    };
    }
    
    NSDictionary *requestNewsdata = @{
                                      
                                      @"appcode":self.extendappModel.appcode,
                                      
                                      @"method":@"LIST",
                                      
                                      @"data":dataDic
                                      
                                      };
    
    
    NSDictionary *parameters = @{
                                            
                                    @"token":[LocalData getToken],
                                            
                                    @"requestdata":requestNewsdata,
                                            
                                };
    
    @weakify(self);
    [HttpsRequestManger sendHttpReqestWithUrl:appmenuModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        [weakself.contentTableView.mj_header endRefreshing];
        [weakself.contentTableView.mj_footer endRefreshing];
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"]isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *dataindexsDic = responsedataDic[@"dataindexs"];
            
            id dataindex = dataindexsDic[@"dataindex"];
            
            
            if ([appmenuModel.appurikind isEqualToString:@"MYHASDONE"] || [appmenuModel.appurikind isEqualToString:@"HASDONE"]) {
                
                if (weakself.pagestart == 1) {
                    
                    [weakself.contentsArray removeAllObjects];

                }
                
            }else{
                
                [weakself.contentsArray removeAllObjects];

            }

            
            
            if ([dataindex isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in dataindex) {
                    
                    DataIndexModel *dataIndexModel = [[DataIndexModel alloc]init];
                    
                    [dataIndexModel setValueFromDic:dic];
                    
                    [weakself.contentsArray addObject:dataIndexModel];
                }
                

            }else if([dataindex isKindOfClass:[NSDictionary class]]){
                
                DataIndexModel *dataIndexModel = [[DataIndexModel alloc]init];
                
                [dataIndexModel setValueFromDic:dataindex];
                
                [weakself.contentsArray addObject:dataIndexModel];

            }
            
            [weakself.contentTableView reloadData];

            
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself requestListDataWithAppmenuModel:appmenuModel];

            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];

            }];

        }
        
    } requestFail:^(NSError *error) {
        
        [weakself.contentTableView.mj_header endRefreshing];
        [weakself.contentTableView.mj_footer endRefreshing];
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
    }];
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
    
    return self.contentsArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ExtendappViewControllerCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DataIndexModel *dataIndexModel = self.contentsArray[indexPath.row];
    
    if (dataIndexModel.isread.integerValue == 0) {
        //未读
        cell.textLabel.textColor = [UIColor redColor];
        
//        cell.imageView.image = [UIImage imageNamed:@"勾-_未选中"];
        
    }else if (dataIndexModel.isread.integerValue == 1){
        //已读
        cell.textLabel.textColor = [UIColor blackColor];
        
//        cell.imageView.image = nil;

    }

    cell.textLabel.text = dataIndexModel.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    DataIndexModel *dataIndexModel = self.contentsArray[indexPath.row];
    
    DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
    
    dataIndexViewController.title = dataIndexModel.title;
    
    dataIndexViewController.url = dataIndexModel.openurl;
    
    [self.navigationController pushViewController:dataIndexViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
