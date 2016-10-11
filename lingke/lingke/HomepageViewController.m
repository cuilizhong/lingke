//
//  HomepageViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HomepageViewController.h"
#import "LocalData.h"
#import "HomeappModel.h"
#import "NewsInfoModel.h"
#import "HomepageCell.h"
#import "ExtendappModel.h"
#import "NewsinfoDetailsViewController.h"
#import "ExtendappViewController.h"
#import "MailListViewController.h"
#import "ApplyModel.h"
#import "LZPopOverMenu.h"
#import "FastApplyViewController.h"
#import "XMLConverter.h"

@interface HomepageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *homeappArray;

@property(nonatomic,strong)NSMutableArray *newsInfoArray;

@property(nonatomic,strong)NSMutableArray *extendappDataArray;

@property(nonatomic,strong)NSMutableArray *applyArray;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.homeappArray = [[NSMutableArray alloc]init];
    
    self.newsInfoArray = [[NSMutableArray alloc]init];
    
    self.extendappDataArray = [[NSMutableArray alloc]init];
    
    self.applyArray = [[NSMutableArray alloc]init];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"fast"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 25, 44);
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 30, 44);
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self requestData];
}


- (void)requestData{
    
    [self showHUDWithMessage:RequestingMessage];
    
    //请求
    NSDictionary *requestdata = @{
                                  
                                  @"unitcode":[LocalData getUnitcode],
                                  
                                  @"method":@"APPLIST"
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    @weakify(self);
    [HttpsRequestManger sendHttpReqestWithUrl:[LocalData getAppcenter] parameter:parameters requestSuccess:^(NSData *data) {
        
        
        [XMLConverter convertXMLData:data completion:^(BOOL success, NSMutableDictionary *dictionary, NSError *error) {
            
            NSLog(@"dictionary = %@",dictionary);

        }];
        

        
        
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
            
            //获取数据成功
            NSLog(@"responsedata = %@", xmlDoc[@"responsedata"]);
            
            NSDictionary *responseDic = xmlDoc[@"responsedata"];
            
            //获取新闻数据
            NSDictionary *homeappDic = [responseDic objectForKey:@"homeapp"];
            
            NSArray *appArray = [homeappDic objectForKey:@"app"];
            
#pragma mark-主功能
            for (NSDictionary *dic in appArray) {
                
                HomeappModel *homeappModel = [[HomeappModel alloc]init];
                
                [homeappModel setValueFromDic:dic];
                
                [weakself.homeappArray addObject:homeappModel];
                
                NSString *appurikindKey = [dic objectForKey:@"appurikind"];
                
                if ([appurikindKey isEqualToString:@"HOMENEWS"]) {
                    
                    //首页新闻
                    [HomeFunctionModel sharedInstance].newsAppModel = homeappModel;
                    
                }else if([appurikindKey isEqualToString:@"APPLY"]){
                    
                    //快速流程接口
                    [HomeFunctionModel sharedInstance].applyAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"ORG"]){
                    //通讯录
                    [HomeFunctionModel sharedInstance].orgAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"HOMETODO"]){
                    //待办
                    [HomeFunctionModel sharedInstance].homeTODOAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"MESSAGE"]){
                    //信息
                    [HomeFunctionModel sharedInstance].messageAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"SCAN"]){
                    //扫描
                    [HomeFunctionModel sharedInstance].scanAppModel = homeappModel;
                    
                }
            }
            
            
#pragma mark-获取扩展功
            NSDictionary *extendappDic = [responseDic objectForKey:@"extendapp"];
            
            NSArray *extendappArray = extendappDic[@"app"];
            
            for (NSDictionary *dic in extendappArray) {
                
                ExtendappModel *extendappModel = [[ExtendappModel alloc]init];
                
                [extendappModel setValueFromDic:dic];
                
                NSDictionary *appmenusDic = dic[@"appmenus"];
                
                NSArray *appmenuArray = appmenusDic[@"appmenu"];
                
                for (NSDictionary *tmpDic in appmenuArray) {
                    
                    AppmenuModel *appmenuModel = [[AppmenuModel alloc]init];
                    
                    [appmenuModel setValueFromDic:tmpDic];
                    
                    [extendappModel.appmenu addObject:appmenuModel];
                    
                }
                
                [extendappModel.appmenus setObject:extendappModel.appmenu forKey:@"appmenus"];
                
                [weakself.extendappDataArray addObject:extendappModel];
                
            }
            
            [weakself requestNews];
            
            [weakself requestWFApplyList];
            
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself requestData];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
            
        }
        
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
    }];
    
}

#pragma mark-请求新闻数据
- (void)requestNews{
    
    HomeappModel *homeappModel = [HomeFunctionModel sharedInstance].newsAppModel;
    
    NSDictionary *data = @{
                           
                           @"pagestart":@"1",
                           
                           @"pagecount":@"4"
                           
                           };
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":homeappModel.appcode,
                                  
                                  @"method":@"NEWSLIST",
                                  
                                  @"data":data
                                  
                                  };
    
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    @weakify(self);
    [HttpsRequestManger sendHttpReqestWithUrl:homeappModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
            
            //获取数据成功
            NSDictionary *responseDic = [xmlDoc objectForKey:@"responsedata"];
            
            NSDictionary *newsinfosDic = responseDic[@"newsinfos"];
            
            NSArray *newsinfoArray = newsinfosDic[@"newsinfo"];
            
            [weakself.newsInfoArray removeAllObjects];
            
            for (NSDictionary *dic in newsinfoArray) {
                
                NewsInfoModel *newsInfoModel = [[NewsInfoModel alloc]init];
                
                [newsInfoModel setValueFromDic:dic];
                
                [weakself.newsInfoArray addObject:newsInfoModel];
            }
            
            //设置新闻
            [weakself.tableView reloadData];
            
            if (weakself.applyArray.count>0) {
                //所有的请求完成
                [weakself hiddenHUD];
            }
            
        }else{
            //获取数据失败
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            [weakself hiddenHUDWithMessage:errorMsg];
            
        }
        
        
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:@"获取失败"];
        
    }];
}

#pragma mark-请求快速申请列表
- (void)requestWFApplyList{
    
    HomeappModel *homeappModel = [HomeFunctionModel sharedInstance].applyAppModel;

    
    NSDictionary *requestdata = @{
                                        @"appcode":homeappModel.appcode,
                                           
                                        @"method":@"WFAPPLYLIST",
                                           
                                    };
    
    
    NSDictionary *parameters = @{
                                      
                                    @"token":[LocalData getToken],
                                      
                                    @"requestdata":requestdata,
                                      
                                };
    
    @weakify(self);
    [HttpsRequestManger sendHttpReqestWithUrl:homeappModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        if ( [[xmlDoc objectForKey:@"statuscode"] isEqualToString:@"0"]) {
            
            NSDictionary *responsedataDic = [xmlDoc objectForKey:@"responsedata"];
            
            NSDictionary *applylistDic = [responsedataDic objectForKey:@"applylist"];
            
            NSArray *applyArray = [applylistDic objectForKey:@"apply"];
            
            [weakself.applyArray removeAllObjects];
            
            for (NSDictionary *dic in applyArray) {
                
                ApplyModel *applyModel = [[ApplyModel alloc]init];
                
                applyModel.applyname = dic[@"applyname"];
                
                applyModel.formid = dic[@"formid"];
                
                [weakself.applyArray addObject:applyModel];
            }
            
            if (weakself.newsInfoArray.count>0) {
                //所有的请求完成
                [weakself hiddenHUD];
            }
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            [weakself hiddenHUDWithMessage:errorMsg];
            
        }

        
    } requestFail:^(NSError *error) {
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
    }];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomepageCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomepageCell" owner:self options:nil]objectAtIndex:indexPath.row];
    
    @weakify(self)
    
    CGSize cellSize = CGSizeMake(self.view.frame.size.width, 160);
    
    [cell showCellWithNewsInfoModelArray:self.newsInfoArray cellSize:cellSize cellIndex:indexPath.row extendappArray:self.extendappDataArray jumpNewsinfoBlock:^(NewsInfoModel *newsInfoModel) {
        
        NSLog(@"跳转到新闻详情");
        
        weakself.hidesBottomBarWhenPushed = YES;
        
        NewsinfoDetailsViewController *newsinfoDetailsViewController = [[NewsinfoDetailsViewController alloc]init];
        
        newsinfoDetailsViewController.newsInfoModel = newsInfoModel;
        
        [weakself.navigationController pushViewController:newsinfoDetailsViewController animated:YES];
        
        weakself.hidesBottomBarWhenPushed = NO;
        
    } enterExtendappBlock:^(ExtendappModel *extendappModel) {
        
        NSLog(@"跳转扩展应用");
        
        weakself.hidesBottomBarWhenPushed = YES;
        
        ExtendappViewController *extendappViewController = [[ExtendappViewController alloc]init];
        
        extendappViewController.extendappModel = extendappModel;
        
        [weakself.navigationController pushViewController:extendappViewController animated:YES];
        
        weakself.hidesBottomBarWhenPushed = NO;
        
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 160.0f;
    }else{
        
        return self.view.frame.size.height - 160.0f - 49;
    }
}


- (void)leftButtonAction:(UIButton *)sender{
    
    //通讯录
    for (HomeappModel *homeappModel in self.homeappArray) {
        
        if ([homeappModel.appurikind isEqualToString:@"ORG"]) {
            
            self.hidesBottomBarWhenPushed = YES;
            
            MailListViewController *mailListViewController = [[MailListViewController alloc]init];
            
            mailListViewController.homeappModel = homeappModel;
            
            [self.navigationController pushViewController:mailListViewController animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
            return;
        }
    }
    
}

- (void)rightButtonAction:(id)sender{
    
    //弹出列表
    NSMutableArray *titlesArray = [[NSMutableArray alloc]init];
    
    for (ApplyModel *applyModel  in self.applyArray) {
        
        
        NSString *title = applyModel.applyname;
        
        [titlesArray addObject:title];
    }
    
    
    [LZPopOverMenu showForSender:sender withMenu:titlesArray imageNameArray:nil doneBlock:^(NSInteger selectedIndex) {
        
        ApplyModel *applyModel = self.applyArray[selectedIndex];
        
        HomeappModel *homeappModel = [HomeFunctionModel sharedInstance].applyAppModel;

        
        
        NSDictionary *data = @{
                               
                               @"formid":applyModel.formid,
                               
                               @"applyname":applyModel.applyname
                               
                               };
        
        
        NSDictionary *requestdata = @{
                                      
                                      @"appcode":homeappModel.appcode,
                                      
                                      @"method":@"WFAPPLY",
                                      
                                      @"data":data
                                      
                                      };
        
        NSDictionary *parameters = @{
                                     
                                     @"token":[LocalData getToken],
                                     
                                     @"requestdata":requestdata,
                                     
                                     };
        
        
        NSString *url = [LocalData getLoginInterface];

        url = [NSString stringWithFormat:@"%@/dataapi/applydata/%@/%@?token=%@",url,homeappModel.appcode,applyModel.formid,[LocalData getToken]];
        
        
        NSLog(@"url = %@",url);
        
        FastApplyViewController *fastApplyViewController = [[FastApplyViewController alloc]init];
        
        fastApplyViewController.url = url;
        
        fastApplyViewController.title = titlesArray[selectedIndex];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:fastApplyViewController animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;

        
//        [[Network alloc]initWithURL:self.applyAppuri parameters:parameters requestSuccess:^(NSData *data) {
//            
//            NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
//            
//            NSLog(@"xmlDoc = %@",xmlDoc);
//            
//        } requestFail:^(NSError *error) {
//            
//        }];
        
        
        
    } dismissBlock:^{
        
    }];
}
@end
