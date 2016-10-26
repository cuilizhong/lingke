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
#import "MenusView.h"
#import "DataIndexViewController.h"
#import "MJRefresh.h"
#import "SPullDownMenuView.h"
#import "ConfigureColor.h"


typedef NS_ENUM(NSInteger, TableViewDataType)
{
    TableViewDataTypeWFList = 0, //default
    TableViewDataTypeWFContent,
    TableViewDataTypeSort,
};


@interface WaittingHandViewController ()<UITableViewDelegate,UITableViewDataSource,SPullDownMenuViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataIndexModelArray;

@property(nonatomic,strong)NSMutableArray *WFListModelArray;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)MenusView *menusView;

@property(nonatomic,assign)TableViewDataType tableViewDataType;

@property(nonatomic,strong)NSMutableArray *contentArray;

@property(nonatomic,strong)NSMutableArray *sortTitleArray;

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)UILabel *tipNoDataLabel;


@property(nonatomic,copy)NSString *currentFormid;

@property(nonatomic,strong)NSArray *titleMenus;

@property(nonatomic,strong)SPullDownMenuView *spullDownMenuView;

@property(nonatomic,strong)NSIndexPath *index;

@end

@implementation WaittingHandViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"待办";
    
    self.currentFormid = @"ALL";
    
    self.tableViewDataType = TableViewDataTypeWFContent;
    
    self.dataIndexModelArray = [[NSMutableArray alloc]init];
    
    self.WFListModelArray = [[NSMutableArray alloc]init];
    
    self.contentArray = [[NSMutableArray alloc]init];
    
//    self.sortTitleArray = [[NSMutableArray alloc]initWithObjects:@"创建时间倒序",@"创建时间正序", nil];
//    
//    self.titleMenus = @[@[@"综合排序", @"价格从低到高", @"价格从高到底", @"信用排序"], @[@"销量优先",@"按倒序"]];
//    
//    self.spullDownMenuView = [[SPullDownMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30) withTitle:self.titleMenus withSelectColor:[ConfigureColor sharedInstance].highBlue];
//    
//    self.spullDownMenuView.delegate = self;
//    
//    [self.view addSubview:self.spullDownMenuView];
    
    @weakify(self)
    self.menusView = [[MenusView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) menusTitle:[[NSMutableArray alloc]initWithObjects:@"所有待办▼",@"创建时间倒序▼", nil] selectedBlock:^(NSString *title) {
        
        if ([title containsString:@"创建时间"] ) {
            
            weakself.tableViewDataType = TableViewDataTypeSort;

        }else{
            weakself.tableViewDataType = TableViewDataTypeWFList;

            
        }
        
        
        [weakself.tableView reloadData];
    }];
    
//    [self.view addSubview:self.menusView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.menusView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height - self.menusView.frame.size.height - 64) style:UITableViewStylePlain];
    
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
            [weakself setBadge:[NSString stringWithFormat:@"%d",i] forIndex:1];
            
            if (i == 0) {
                
                [weakself setBadge:nil forIndex:3];
                
            }
            
            
            if (weakself.WFListModelArray.count>0) {
                
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
            
            
            //请求分类完成之后 创建menu
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (WFListModel *tmpWFListModel in weakself.WFListModelArray) {
                
                [array addObject:tmpWFListModel.wfname];
            }
            

            weakself.titleMenus = @[array, @[@"创建时间倒序",@"创建时间正序"]];
            
            if (weakself.spullDownMenuView) {
                
                [weakself.spullDownMenuView removeFromSuperview];
            }
            
            weakself.spullDownMenuView = [[SPullDownMenuView alloc] initWithFrame:CGRectMake(0, 0, weakself.view.frame.size.width, 30) withTitle:weakself.titleMenus withSelectColor:[ConfigureColor sharedInstance].highBlue];
            
            weakself.spullDownMenuView.delegate = self;
            
            [weakself.view addSubview:self.spullDownMenuView];
            
            
            //处理分类
            if (weakself.dataIndexModelArray.count>0) {
                
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

//#pragma mark-暂时不需要
//- (void)handClassWithWfList:(NSArray *)wfList{
//    
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    
//    for (WFListModel *wFListModel in wfList) {
//        
//        if (![array containsObject:wFListModel.formid]) {
//            
//            [array addObject:wFListModel.formid];
//        }
//    }
//    
//    //array中是种类
//    for (NSString *formid in array) {
//        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//        NSString *wfname;
//        NSInteger count = 0;;
//        
//        for (WFListModel *wFListModel in wfList) {
//            
//            if ([wFListModel.formid isEqualToString:formid]) {
//                
//                wfname = wFListModel.wfname;
//                
//                count++;
//            }
//        }
//        
//        [dic setObject:wfname forKey:@"wfname"];
//        [dic setObject:[NSString stringWithFormat:@"%ld",count] forKey:@"count"];
//        [dic setObject:formid forKey:@"formid"];
//        [self.WFListModelArray addObject:dic];
//        
//    }
//    
//    NSLog(@"self.wflistModelArray = %@",self.WFListModelArray);
//    
//}



#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.tableViewDataType == TableViewDataTypeWFList) {
        
        return self.WFListModelArray.count;

    }else if(self.tableViewDataType == TableViewDataTypeWFContent){
        
        return self.contentArray.count;
    }else{
        
        return self.sortTitleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableViewDataType == TableViewDataTypeWFList) {
        
        static NSString *cellID = @"cellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        WFListModel *wFListModel = self.WFListModelArray[indexPath.row];
        
        
        NSMutableAttributedString *wfname = [[NSMutableAttributedString alloc] initWithString:wFListModel.wfname];
        
        NSMutableAttributedString *leftAttributed = [[NSMutableAttributedString alloc] initWithString:@" (" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        
        NSMutableAttributedString *wfnameAttributed = [[NSMutableAttributedString alloc] initWithString:wFListModel.count attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
        
        NSMutableAttributedString *rightAttributed = [[NSMutableAttributedString alloc] initWithString:@")" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        [wfname appendAttributedString:leftAttributed];
        
        [wfname appendAttributedString:wfnameAttributed];
        
        [wfname appendAttributedString:rightAttributed];
        
        cell.textLabel.attributedText = wfname;
        
        return cell;
        
    }else if(self.tableViewDataType == TableViewDataTypeWFContent){
        
        static NSString *cellID = @"ContentCellID";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        DataIndexModel *dataIndexModel = self.contentArray[indexPath.row];
        
        if (dataIndexModel.isread.integerValue == 0) {
            //未读
            cell.textLabel.textColor = [UIColor redColor];
            cell.imageView.image = [UIImage imageNamed:@"勾-_未选中"];
            
        }else if (dataIndexModel.isread.integerValue == 1){
            //已读
            cell.textLabel.textColor = [UIColor blackColor];
            
            cell.imageView.image = nil;
        }
        
        cell.textLabel.text = dataIndexModel.title;
        
        return cell;
        
    }else{
        
        static NSString *cellID = @"SortCellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        
        cell.textLabel.text = self.sortTitleArray[indexPath.row];
        
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //处理数据
    if (self.tableViewDataType == TableViewDataTypeWFList) {
        
        WFListModel *wfListModel = self.WFListModelArray[indexPath.row];
        
        self.currentFormid = wfListModel.formid;
        
        NSString *wfname = wfListModel.wfname;
        [self.menusView.menusTitleArray removeObjectAtIndex:0];
        [self.menusView.menusTitleArray insertObject:[NSString stringWithFormat:@"%@▼",wfname] atIndex:0];
        
        self.menusView.selectedTitle = [NSString stringWithFormat:@"%@▼",wfname];
        
        [self.menusView.tableView reloadData];
        
        self.tableViewDataType = TableViewDataTypeWFContent;
        
        [self handDataWithFormid:wfListModel.formid];
        
        if (self.contentArray.count>0) {
            
            self.tipNoDataLabel.hidden = YES;
            
        }else{
            
            self.tipNoDataLabel.hidden = NO;
        }

    }else if (self.tableViewDataType == TableViewDataTypeSort){
        
        self.tableViewDataType = TableViewDataTypeWFContent;
        
        if (indexPath.row == 0) {
            //@"所有待办▼",@"创建时间倒序▼"
            [self.menusView.menusTitleArray removeLastObject];

            [self.menusView.menusTitleArray addObject:@"创建时间倒序▼"];
            self.menusView.selectedTitle = @"创建时间倒序▼";
            [self.menusView.tableView reloadData];

            
            [self handSort:YES];
            
        }else if(indexPath.row == 1){
            
            [self.menusView.menusTitleArray removeLastObject];
            [self.menusView.menusTitleArray addObject:@"创建时间正序▼"];
            self.menusView.selectedTitle = @"创建时间正序▼";

            [self.menusView.tableView reloadData];
            
            [self handSort:NO];
            
        }
        
        if (self.contentArray.count>0) {
            
            self.tipNoDataLabel.hidden = YES;
            
        }else{
            
            self.tipNoDataLabel.hidden = NO;
        }
        
        
    }else if (self.tableViewDataType == TableViewDataTypeWFContent){
        
        //进入待办
        DataIndexModel *dataIndexModel = self.contentArray[indexPath.row];
        
        DataIndexViewController *viewController =  [[DataIndexViewController alloc]init];
        
        viewController.title = dataIndexModel.title;
        
        viewController.url = dataIndexModel.openurl;
        
//        viewController.dataIndexModel = dataIndexModel;
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
        
    }
    
    
    
    
    
}

- (void)handDataWithFormid:(NSString *)formid{
    
    [self.contentArray removeAllObjects];
    
    if ([formid isEqualToString:@"ALL"]) {
        
        [self.contentArray addObjectsFromArray:self.dataIndexModelArray];
        
        [self.tableView reloadData];
        
        return;
    }
    
    for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
        
        if ([dataIndexModel.formid isEqualToString:formid]) {
            
            [self.contentArray addObject:dataIndexModel];
        }
    }
    
    [self.tableView reloadData];
    
    
    switch (self.tableViewDataType) {
            
        case TableViewDataTypeWFList:{
            
            if (self.WFListModelArray.count>0) {
                
                self.tipNoDataLabel.hidden = YES;
                
            }else{
                
                self.tipNoDataLabel.hidden = NO;
            }
            
        }
            
            break;
            
        case TableViewDataTypeWFContent:{
            
            if (self.contentArray.count>0) {
                
                self.tipNoDataLabel.hidden = YES;
                
            }else{
                
                self.tipNoDataLabel.hidden = NO;
            }
            
        }
            
            break;
            
        case TableViewDataTypeSort:{
            
            if (self.sortTitleArray.count>0) {
                
                self.tipNoDataLabel.hidden = YES;
                
            }else{
                
                self.tipNoDataLabel.hidden = NO;
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
}


- (void)handCount{
    
    NSLog(@"调用");
    
    [self hiddenHUD];
    
    [self.tableView.mj_header endRefreshing];

    
    for (WFListModel *wflistModel in self.WFListModelArray) {
        
        NSInteger count = 0;
        
        for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
            
            if ([dataIndexModel.formid isEqualToString:wflistModel.formid]) {
                
                count++;
            }
            
            if (dataIndexModel.isread.integerValue == 0) {
                
                self.count++;
            }
        }
        
        wflistModel.count = [NSString stringWithFormat:@"%ld",count];
        
    }
    
    WFListModel *wflistModel = self.WFListModelArray[0];
    
    wflistModel.count =  [NSString stringWithFormat:@"%lu",(unsigned long)self.dataIndexModelArray.count];
    
    [self.contentArray removeAllObjects];
    
    [self.contentArray addObjectsFromArray:self.dataIndexModelArray];
    
    [self.tableView reloadData];
    
    
    self.count = 0;
    
    for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
        
        if (dataIndexModel.isread.integerValue == 0) {
            
            self.count++;
        }
    }
    
//    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
//    item.badgeValue = [NSString stringWithFormat:@"%ld",(long)self.count];
    
    
    
    
    [self handDataWithFormid:self.currentFormid];

}

- (void)handSort:(BOOL)isReverse{
    
    [self.contentArray removeAllObjects];
    
    if (isReverse) {
        
        [self.contentArray addObjectsFromArray:self.dataIndexModelArray];
        
    }else{
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        
        //先正序
        for (NSInteger i = self.dataIndexModelArray.count-1; i>=0; i--) {
            
            DataIndexModel *dataIndexModel = self.dataIndexModelArray[i];
            
            [tmpArray addObject:dataIndexModel];
        }
        

        
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
    
    [self.tableView reloadData];

    
    
}

#pragma mark-SPullDownMenuViewDelegate
- (void)pullDownMenuView:(SPullDownMenuView *)menu didSelectedIndex:(NSIndexPath *)indexPath{
    
    //选择
    
    self.index = indexPath;
    
    WFListModel *wfListModel = self.WFListModelArray[indexPath.row];

    self.tableViewDataType = TableViewDataTypeWFContent;
    
    [self handDataWithFormid:wfListModel.formid];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
