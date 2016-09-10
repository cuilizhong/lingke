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

@interface WaittingHandViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataIndexModelArray;

@property(nonatomic,strong)NSMutableArray *WFListModelArray;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation WaittingHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarItem.badgeValue = @"1";
    
    self.title = @"待办";
    
    self.dataIndexModelArray = [[NSMutableArray alloc]init];
    
    self.WFListModelArray = [[NSMutableArray alloc]init];
    
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
    
    @weakify(self);
    
    [HttpsRequestManger sendHttpReqestWithUrl:appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *dataindexsDic = responsedataDic[@"dataindexs"];
            
            NSArray *dataindexArray = dataindexsDic[@"dataindex"];
            
            for (NSDictionary *dic in dataindexArray) {
                
                DataIndexModel *dataIndexModel = [[DataIndexModel alloc]init];
                
                [dataIndexModel setValueFromDic:dic];
                
                [weakself.dataIndexModelArray addObject:dataIndexModel];
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
            
            for (NSDictionary *dic in wfArray) {
                
                WFListModel *wFListModel = [[WFListModel alloc]init];
                
                [wFListModel setValueFromDic:dic];
                
                [self.WFListModelArray addObject:wFListModel];
            }
            
            
            
            
        }else{
            
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            NSLog(@"errorMessage = %@",errorMessage);
            
        }
        
        
    } requestFail:^(NSError *error) {
        
    }];
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0) style:UITableViewStylePlain];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
