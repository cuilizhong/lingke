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

typedef NS_ENUM(NSInteger, TableViewDataType)
{
    TableViewDataTypeWFList = 0, //default
    TableViewDataTypeWFContent,
    TableViewDataTypeSort,
};


@interface WaittingHandViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataIndexModelArray;

@property(nonatomic,strong)NSMutableArray *WFListModelArray;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)MenusView *menusView;

@property(nonatomic,assign)TableViewDataType tableViewDataType;

@property(nonatomic,strong)NSMutableArray *contentArray;

@property(nonatomic,strong)NSMutableArray *sortTitleArray;

@end

@implementation WaittingHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarItem.badgeValue = @"1";
    
    self.title = @"待办";
    
    self.tableViewDataType = TableViewDataTypeWFList;
    
    self.dataIndexModelArray = [[NSMutableArray alloc]init];
    
    self.WFListModelArray = [[NSMutableArray alloc]init];
    
    self.contentArray = [[NSMutableArray alloc]init];
    
    self.sortTitleArray = [[NSMutableArray alloc]initWithObjects:@"创建时间倒序",@"创建时间正序", nil];
    
    
    @weakify(self)
    self.menusView = [[MenusView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 40) menusTitle:[[NSMutableArray alloc]initWithObjects:@"所有待办",@"创建时间倒序", nil] selectedBlock:^(NSString *title) {
        
        if ([title isEqualToString:@"所有待办"]) {
            
            weakself.tableViewDataType = TableViewDataTypeWFList;
            
        }else{
            
            weakself.tableViewDataType = TableViewDataTypeSort;
            

        }
        
        [weakself.tableView reloadData];

        
    }];
    
    [self.view addSubview:self.menusView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.menusView.frame.size.height + 64, self.view.frame.size.width,self.view.frame.size.height - self.menusView.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
    [self hiddenSurplusLine:self.tableView];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //request
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
            
            NSArray *dataindexArray = dataindexsDic[@"dataindex"];
            
            [weakself.dataIndexModelArray removeAllObjects];
            
            for (NSDictionary *dic in dataindexArray) {
                
                DataIndexModel *dataIndexModel = [[DataIndexModel alloc]init];
                
                [dataIndexModel setValueFromDic:dic];
                
                [weakself.dataIndexModelArray addObject:dataIndexModel];
            }
            
            if (self.WFListModelArray.count>0) {
                
                [weakself handCount];
                
            }
            
            
        }else{
            
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            NSLog(@"errorMessage = %@",errorMessage);
            
        }

        
    } requestFail:^(NSError *error) {
        
    }];
    
    
    [self requestClass];
}

- (void)requestClass{
    
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
            
            NSArray *wfArray = wflistDic[@"wf"];
            
//            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in wfArray) {
                
                WFListModel *wFListModel = [[WFListModel alloc]init];
                
                [wFListModel setValueFromDic:dic];
                
                [self.WFListModelArray addObject:wFListModel];
                
            }
            
            
            //处理分类
            if (self.dataIndexModelArray.count>0) {
                
                [weakself handCount];
                
                
            }
            
            
            
            
            
        }else{
            
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            NSLog(@"errorMessage = %@",errorMessage);
            
        }
        
        
    } requestFail:^(NSError *error) {
        
    }];
}

#pragma mark-暂时不需要
- (void)handClassWithWfList:(NSArray *)wfList{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (WFListModel *wFListModel in wfList) {
        
        if (![array containsObject:wFListModel.formid]) {
            
            [array addObject:wFListModel.formid];
        }
    }
    
    //array中是种类
    for (NSString *formid in array) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSString *wfname;
        NSInteger count = 0;;
        
        for (WFListModel *wFListModel in wfList) {
            
            if ([wFListModel.formid isEqualToString:formid]) {
                
                wfname = wFListModel.wfname;
                
                count++;
            }
        }
        
        [dic setObject:wfname forKey:@"wfname"];
        [dic setObject:[NSString stringWithFormat:@"%ld",count] forKey:@"count"];
        [dic setObject:formid forKey:@"formid"];
        [self.WFListModelArray addObject:dic];
        
    }
    
    NSLog(@"self.wflistModelArray = %@",self.WFListModelArray);
    
}



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
        
        self.tableViewDataType = TableViewDataTypeWFContent;
        
        [self handDataWithFormid:wfListModel.formid];

    }else if (self.tableViewDataType == TableViewDataTypeSort){
        
        self.tableViewDataType = TableViewDataTypeWFContent;
        
        if (indexPath.row == 0) {
            
            [self handSort:YES];
            
        }else if(indexPath.row == 1){
            
            [self handSort:NO];
            
        }
        
        
    }else if (self.tableViewDataType == TableViewDataTypeWFContent){
        
    }
    
    
    
    
}

- (void)handDataWithFormid:(NSString *)formid{
    
    [self.contentArray removeAllObjects];
    
    for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
        
        if ([dataIndexModel.formid isEqualToString:formid]) {
            
            [self.contentArray addObject:dataIndexModel];
        }
    }
    
    [self.tableView reloadData];
    
}


- (void)handCount{
    
    for (WFListModel *wflistModel in self.WFListModelArray) {
        
        NSInteger count = 0;
        
        for (DataIndexModel *dataIndexModel in self.dataIndexModelArray) {
            
            if ([dataIndexModel.formid isEqualToString:wflistModel.formid]) {
                
                count++;
            }
        }
        
        wflistModel.count = [NSString stringWithFormat:@"%ld",count];
        
    }
    
    [self.tableView reloadData];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end