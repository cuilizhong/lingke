//
//  WaittingHandViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "WaittingHandViewController.h"
#import "DataIndexModel.h"
#import "WFListModel.h"
#import "DataIndexViewController.h"
#import "MJRefresh.h"
#import "SPullDownMenuView.h"
#import "ConfigureColor.h"


static CGFloat menuHeight = 30.0f;

typedef NS_ENUM(NSInteger, TableViewDataType)
{
    TableViewDataTypeWFList = 0, //default
    TableViewDataTypeWFContent,
    TableViewDataTypeSort,
};


@interface WaittingHandViewController ()<UITableViewDelegate,UITableViewDataSource,SPullDownMenuViewDelegate>

//所有的数据
@property(nonatomic,strong)NSMutableArray *dataIndexModelArray;

//分类
@property(nonatomic,strong)NSMutableArray *WFListModelArray;

//展示的数据
@property(nonatomic,strong)NSMutableArray *contentArray;


@property(nonatomic,strong)UITableView *tableView;

//未读总数
@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)UILabel *tipNoDataLabel;


@property(nonatomic,copy)NSString *currentFormid;

@property(nonatomic,strong)NSArray *titleMenus;

@property(nonatomic,strong)SPullDownMenuView *spullDownMenuView;


@property(nonatomic,assign)BOOL isWFListRequestSuccess;

@property(nonatomic,assign)BOOL isDataIndexRequestSuccess;




@end

@implementation WaittingHandViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"待办";
    
    self.dataIndexModelArray = [[NSMutableArray alloc]init];
    
    self.WFListModelArray = [[NSMutableArray alloc]init];
    
    self.contentArray = [[NSMutableArray alloc]init];
    
    
    @weakify(self)
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,menuHeight, self.view.frame.size.width,self.view.frame.size.height - menuHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];

    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [weakself request];
        
        [weakself requestClass];
    }];
    
    [self hiddenSurplusLine:self.tableView];
    
    self.tipNoDataLabel = [[UILabel alloc]init];
    self.tipNoDataLabel.text = @"无待办";
    self.tipNoDataLabel.font = [UIFont systemFontOfSize:14];
    self.tipNoDataLabel.textColor = [UIColor darkGrayColor];
    self.tipNoDataLabel.textAlignment = NSTextAlignmentCenter;
    self.tipNoDataLabel.backgroundColor = [UIColor clearColor];
    self.tipNoDataLabel.center = self.view.center;
    self.tipNoDataLabel.frame = CGRectMake(0,self.tipNoDataLabel.frame.origin.y-60, self.view.frame.size.width, 30);
    [self.view addSubview:self.tipNoDataLabel];
    self.tipNoDataLabel.hidden = YES;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.spullDownMenuView tapClick];
}

- (void)request{
    
    [self showHUD];
    
    //request
    @weakify(self)
    NSString *appcode = [HomeFunctionModel sharedInstance].homeTODOAppModel.appcode;
    
    NSString *appuri = [HomeFunctionModel sharedInstance].homeTODOAppModel.appuri;
    
    NSDictionary *data = @{
                           
                           @"formid":@"ALL",
                           
                           };
    
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":appcode,
                                  
                                  @"method":@"TODOLIST",
                                  
                                  @"data":data
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    [HttpsRequestManger sendHttpReqestWithUrl:appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            weakself.isDataIndexRequestSuccess = YES;
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *dataindexsDic = responsedataDic[@"dataindexs"];
            
            id dataindexArray = dataindexsDic[@"dataindex"];
            
            [weakself.dataIndexModelArray removeAllObjects];
            
            if ([dataindexArray isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in dataindexArray) {
                    
                    DataIndexModel *dataIndexModel = [[DataIndexModel alloc]init];
                    
                    [dataIndexModel setValueFromDic:dic];
                    
                    [weakself.dataIndexModelArray addObject:dataIndexModel];
                }
                
            }else if ([dataindexArray isKindOfClass:[NSDictionary class]]){
                
                DataIndexModel *dataIndexModel = [[DataIndexModel alloc]init];
                
                [dataIndexModel setValueFromDic:dataindexArray];
                
                [weakself.dataIndexModelArray addObject:dataIndexModel];
            }
            
            //计算下面的数字
            int i = 0;
            for (DataIndexModel *tmpDataIndexModel in weakself.dataIndexModelArray) {
                
                if (tmpDataIndexModel.isread.integerValue == 0) {
                    i++;
                }
                
            }
            
            if (i>0) {
                
                [weakself setBadge:[NSString stringWithFormat:@"%d",i] forIndex:1];

            }else{
                
                [weakself setBadge:nil forIndex:1];

            }

            //修改
            if (weakself.isWFListRequestSuccess && weakself.isDataIndexRequestSuccess) {
                
                weakself.isDataIndexRequestSuccess = NO;
                
                weakself.isWFListRequestSuccess = NO;
                
                [weakself handCount];

            }
            
            
            
            
            
            
        }else{
            
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself request];
                
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself.tableView.mj_header endRefreshing];

                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
            
        }
        
        
    } requestFail:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        
        [weakself hiddenHUDWithMessage:@"加载失败"];
        
    }];
    
}

- (void)requestClass{
    
    [self showHUD];
    
    NSString *appcode = [HomeFunctionModel sharedInstance].homeTODOAppModel.appcode;
    
    NSString *appuri = [HomeFunctionModel sharedInstance].homeTODOAppModel.appuri;
    
    
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":appcode,
                                  
                                  @"method":@"WFCATEGORY",
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    @weakify(self);
    
    [HttpsRequestManger sendHttpReqestWithUrl:appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"分类xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            weakself.isWFListRequestSuccess = YES;
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *wflistDic = responsedataDic[@"wflist"];
            
            id wfArray = wflistDic[@"wf"];
            
            [weakself.WFListModelArray removeAllObjects];
            
            if ([wfArray isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in wfArray) {
                    
                    WFListModel *wFListModel = [[WFListModel alloc]init];
                    
                    [wFListModel setValueFromDic:dic];
                    
                    [weakself.WFListModelArray addObject:wFListModel];
                    
                }
                
            }else if ([wfArray isKindOfClass:[NSDictionary class]]){
                
                WFListModel *wFListModel = [[WFListModel alloc]init];
                
                [wFListModel setValueFromDic:wfArray];
                
                [weakself.WFListModelArray addObject:wFListModel];
            }
            
            WFListModel *allWFListModel = [[WFListModel alloc]init];

            allWFListModel.wfname = @"所有待办";
            
            allWFListModel.formid = @"ALL";
            
            [weakself.WFListModelArray insertObject:allWFListModel atIndex:0];
            
            
            
            //处理分类
            //修改
            if (weakself.isWFListRequestSuccess && weakself.isDataIndexRequestSuccess) {
                
                weakself.isDataIndexRequestSuccess = NO;
                
                weakself.isWFListRequestSuccess = NO;
                
                [weakself handCount];
                
            }
            
            
            
        }else{
            
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself requestClass];
                
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself.tableView.mj_header endRefreshing];
                
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];

        }
        
    } requestFail:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        
        [weakself hiddenHUDWithMessage:@"加载失败"];

    }];
}


#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ContentCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    DataIndexModel *dataIndexModel = self.contentArray[indexPath.row];
    
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
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //进入待办
    DataIndexModel *dataIndexModel = self.contentArray[indexPath.row];
    
    DataIndexViewController *viewController =  [[DataIndexViewController alloc]init];
    
    viewController.title = dataIndexModel.title;
    
    viewController.url = dataIndexModel.openurl;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}



#pragma mark-处理数量
- (void)handCount{
    
    self.currentFormid = @"ALL";
    
    [self hiddenHUD];
    
    [self.tableView.mj_header endRefreshing];

    //计算每个分类下有多少条
    for (WFListModel *wflistModel in self.WFListModelArray) {
        
        NSInteger count = 0;
        
        for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
            
            if ([dataIndexModel.formid isEqualToString:wflistModel.formid]) {
                
                count++;
            }
            
        }
        
        wflistModel.count = [NSString stringWithFormat:@"%ld",count];
        
    }
    
    //所有待办有多少条数据
    WFListModel *wflistModel = self.WFListModelArray[0];
    
    wflistModel.count =  [NSString stringWithFormat:@"%lu",(unsigned long)self.dataIndexModelArray.count];
    
    
    //计算有多少是未读
    self.count = 0;
    
    for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
        
        if (dataIndexModel.isread.integerValue == 0) {
            
            self.count++;
        }
    }
    
    
    //请求分类完成之后 创建menu
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (WFListModel *tmpWFListModel in self.WFListModelArray) {
        
        NSString *str = [NSString stringWithFormat:@"%@(%@)",tmpWFListModel.wfname,tmpWFListModel.count];
        
        [array addObject:str];
    }
    
    
    self.titleMenus = @[array, @[@"创建时间倒序",@"创建时间正序"]];
    
    if (self.spullDownMenuView) {
        
        [self.spullDownMenuView removeFromSuperview];
    }
    
    self.spullDownMenuView = [[SPullDownMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, menuHeight) withTitle:self.titleMenus withSelectColor:[ConfigureColor sharedInstance].highBlue];
    
    self.spullDownMenuView.delegate = self;
    
    [self.view addSubview:self.spullDownMenuView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,29.5, self.spullDownMenuView.frame.size.width, 0.5)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.spullDownMenuView addSubview:lineView];

    
    
    
    
    
    
    [self handDataWithFormid:self.currentFormid];
}

#pragma mark-显示数据
- (void)handDataWithFormid:(NSString *)formid{
    
    [self.contentArray removeAllObjects];
    
    if ([formid isEqualToString:@"ALL"]) {
        
        [self.contentArray addObjectsFromArray:self.dataIndexModelArray];
        
        [self.tableView reloadData];
        
        
        if (self.contentArray.count>0) {
            
            self.tipNoDataLabel.hidden = YES;
            
        }else{
            
            self.tipNoDataLabel.hidden = NO;
            
        }
        
        
        
        return;
    }
    
    for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
        
        if ([dataIndexModel.formid isEqualToString:formid]) {
            
            [self.contentArray addObject:dataIndexModel];
        }
    }
    
    if (self.contentArray.count>0) {
        
        self.tipNoDataLabel.hidden = YES;
        
    }else{
        
        self.tipNoDataLabel.hidden = NO;
        
    }
    
    [self.tableView reloadData];
}

#pragma mark-排序
- (void)handSort:(BOOL)isReverse{
    
    [self handDataWithFormid:self.currentFormid];
    
    if (isReverse) {
        //倒序
        
    }else{
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        
        //先正序
        for (NSInteger i = self.contentArray.count-1; i>=0; i--) {
            
            DataIndexModel *dataIndexModel = self.contentArray[i];
            
            [tmpArray addObject:dataIndexModel];
        }
        
        [self.contentArray removeAllObjects];
        
        for (DataIndexModel *dataIndexModel in tmpArray) {
            
            if (dataIndexModel.isread.integerValue == 0) {
                
                [self.contentArray addObject:dataIndexModel];
            }
        }
        
        for (DataIndexModel *dataIndexModel in tmpArray) {
            
            if (dataIndexModel.isread.integerValue == 1) {
                
                [self.contentArray addObject:dataIndexModel];
            }
        }
        
    }
    
    if (self.contentArray.count>0) {
        
        self.tipNoDataLabel.hidden = YES;
        
    }else{
        
        self.tipNoDataLabel.hidden = NO;

    }
    
    [self.tableView reloadData];
    
}

#pragma mark-SPullDownMenuViewDelegate
- (void)pullDownMenuView:(SPullDownMenuView *)menu didSelectedIndex:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        WFListModel *tmpWfListModel = self.WFListModelArray[indexPath.section];
        
        self.currentFormid = tmpWfListModel.formid;
        
        [self handDataWithFormid:self.currentFormid];

    }else{
        
        [self handSort:indexPath.section];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
