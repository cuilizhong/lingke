//
//  MyFriendViewController.m
//  lingke
//
//  Created by clz on 16/10/4.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MyFriendViewController.h"
#import "MJRefresh.h"
#import "PersionModel.h"
#import "MailListTableViewCell.h"


@interface MyFriendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UILabel *tipNoDataLabel;

@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    switch (self.mailListState) {
            
        case MailListState_Friend:
            
            self.title = @"我的好友";
            break;
            
        case MailListState_Grounp:
            
            self.title = @"我的群组";
            break;
            
        case MailListState_Follow:
            
            self.title = @"我的关注";
            break;
            
        default:
            break;
    }
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    @weakify(self)
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [weakself requestMailList];
        
    }];
    
    self.tipNoDataLabel = [[UILabel alloc]init];
    self.tipNoDataLabel.text = @"暂无数据";
    self.tipNoDataLabel.font = [UIFont systemFontOfSize:14];
    self.tipNoDataLabel.textColor = [UIColor blackColor];
    self.tipNoDataLabel.textAlignment = NSTextAlignmentCenter;
    self.tipNoDataLabel.backgroundColor = [UIColor clearColor];
    self.tipNoDataLabel.center = self.view.center;
    self.tipNoDataLabel.frame = CGRectMake(0,self.view.frame.origin.y-30, self.view.frame.size.width, 30);
    [self.view addSubview:self.tipNoDataLabel];
    self.tipNoDataLabel.hidden = YES;
}

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCellID"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
    }
    
    PersionModel *persion = self.dataArray[indexPath.row];
    
    cell.cell1Label.text = persion.username;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

#pragma mark-请求数据
- (void)requestMailList{
    
    [self showHUDWithMessage:@"加载中，请稍后"];
    
    NSDictionary *data = @{
                           
                           @"pagestart":@"1",
                           
                           @"pagecount":@"5000",
                           
                           @"kind":@"ALL",
                           
                           };
    
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":self.homeappModel.appcode,
                                  
                                  @"method":@"PERSONLIST",
                                  
                                  @"data":data
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    @weakify(self)
    
    [HttpsRequestManger sendHttpReqestWithUrl:self.homeappModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        [weakself.tableView.mj_header endRefreshing];
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        NSDictionary *responsedata = xmlDoc[@"responsedata"];
        
        NSString *statuscode = xmlDoc[@"statuscode"];
        
        if ([statuscode isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            //数据获取成功
            NSDictionary *persons = responsedata[@"persons"];
            
            NSArray *personArray = persons[@"person"];
            
            [weakself.dataArray removeAllObjects];
            
            for (NSDictionary *dic in personArray) {
                
                PersionModel *persion = [[PersionModel alloc]init];
                
                [persion setValueFromDic:dic];
                
                switch (self.mailListState) {
                        
                    case MailListState_Friend:{
                        
                        if (persion.isfriend.integerValue == 1) {
                            
                            [weakself.dataArray addObject:persion];

                        }
                        
                    }
                        
                        break;
                        
                    case MailListState_Grounp:{
                        
                        if (persion.ismygroup.integerValue == 1) {
                            
                            [weakself.dataArray addObject:persion];
                        }
                        
                    }
                        
                        break;
                        
                    case MailListState_Follow:{
                        
                        if (persion.isattention.integerValue == 1) {
                            
                            [weakself.dataArray addObject:persion];
                        }
                        
                    }
                        
                        break;
                        
                    default:
                        break;
                }
            }
            
            if (weakself.dataArray.count>0) {
                
                weakself.tipNoDataLabel.hidden = YES;
                
            }else{
                
                weakself.tipNoDataLabel.hidden = NO;
            }
            
            [weakself.tableView reloadData];
            
            
        }else if([statuscode isEqualToString:TokenInvalidCode]){
            
            //处理token过期
            [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:^{
                
                [weakself requestMailList];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself showHUDWithMessage:errorMessage];
                
            }];
            
            
        }else{
            
            //数据获取失败
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            [weakself showHUDWithMessage:errorMessage];
        }
        
    } requestFail:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        
        [weakself showHUDWithMessage:RequestFailureMessage];
        
    }];
}

@end
