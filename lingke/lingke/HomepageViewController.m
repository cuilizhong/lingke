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

@interface HomepageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *homeappArray;

@property(nonatomic,strong)NSMutableArray *newsInfoArray;

@property(nonatomic,strong)NSMutableArray *extendappDataArray;

@property(nonatomic,strong)NSMutableArray *applyArray;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)NSString *applyAppCode;

@property(nonatomic,copy)NSString *applyAppuri;


@end

@implementation HomepageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.homeappArray = [[NSMutableArray alloc]init];
    
    self.newsInfoArray = [[NSMutableArray alloc]init];
    
    self.extendappDataArray = [[NSMutableArray alloc]init];
    
    self.applyArray = [[NSMutableArray alloc]init];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"TabBar_Item_1"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 50, 20);
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    NSDictionary *requestdata = @{
                                  
                                  @"unitcode":[LocalData getUnitcode],
                                  
                                  @"method":@"APPLIST"
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                                                  
                                 };
    
    Network *appcodeNetwork = [[Network alloc]initWithURL:[UserinfoModel sharedInstance].uri parameters:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
            
            //获取数据成功
            NSLog(@"responsedata = %@", xmlDoc[@"responsedata"]);
            
            NSDictionary *responseDic = xmlDoc[@"responsedata"];
            
            //获取新闻数据
            NSDictionary *homeappDic = [responseDic objectForKey:@"homeapp"];
            
            NSArray *appArray = [homeappDic objectForKey:@"app"];
            
            NSString *appcode;
            
            NSString *appuri;
            
            
            //主功能
            for (NSDictionary *dic in appArray) {
                
                HomeappModel *homeappModel = [[HomeappModel alloc]init];
                
                [homeappModel setValueFromDic:dic];
                
                [self.homeappArray addObject:homeappModel];
                
                NSString *appurikindKey = [dic objectForKey:@"appurikind"];
                
                if ([appurikindKey isEqualToString:@"HOMENEWS"]) {
                    
                    //首页新闻
                    appcode = [dic objectForKey:@"appcode"];
                    appuri = [dic objectForKey:@"appuri"];
                    
                    [HomeFunctionModel sharedInstance].newsAppModel = homeappModel;
                    
                }else if([appurikindKey isEqualToString:@"APPLY"]){
                    
                    //快速流程接口
                    self.applyAppCode = [dic objectForKey:@"appcode"];
                    self.applyAppuri = [dic objectForKey:@"appuri"];
                    
                    [HomeFunctionModel sharedInstance].applyAppModel = homeappModel;
                    
                    
                }else if ([appurikindKey isEqualToString:@"ORG"]){
                    //通讯录
                    [HomeFunctionModel sharedInstance].orgAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"HOMETODO"]){
                    
                    [HomeFunctionModel sharedInstance].homeTODOAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"MESSAGE"]){
                    
                    [HomeFunctionModel sharedInstance].messageAppModel = homeappModel;
                    
                }else if ([appurikindKey isEqualToString:@"SCAN"]){
                    
                    [HomeFunctionModel sharedInstance].scanAppModel = homeappModel;
                    
                }
                
                
            }
            
            
            //获取扩展功能数据
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
                
                [self.extendappDataArray addObject:extendappModel];
                
            }
            
            NSLog(@"self.extendappDataArray = %@",self.extendappDataArray);
            
            
#pragma mark-请求首页新闻
            NSDictionary *dataDic = @{
                                      
                                      @"pagestart":@"1",
                                      
                                      @"pagecount":@"4"
                                      
                                      };
            
            NSDictionary *requestNewsdata = @{
                                          
                                          @"appcode":appcode,
                                          
                                          @"method":@"NEWSLIST",
                                          
                                          @"data":dataDic
                                          
                                          };
            
            
            NSDictionary *requestNewsparameters = @{
                                         
                                         @"token":[LocalData getToken],
                                         
                                         @"requestdata":requestNewsdata,
                                         
                                         };
            

            
            NSLog(@"requestNewsparameters = %@",requestNewsparameters);
            
            Network *newsNetwork = [[Network alloc]initWithURL:appuri parameters:requestNewsparameters requestSuccess:^(NSData *data) {
                
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
                
                NSLog(@"xmlDoc = %@",xmlDoc);
                
                if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
                    
                    //获取数据成功
                    NSDictionary *responseDic = [xmlDoc objectForKey:@"responsedata"];
                    
                    NSDictionary *newsinfosDic = responseDic[@"newsinfos"];
                    
                    NSArray *newsinfoArray = newsinfosDic[@"newsinfo"];
                    
                    for (NSDictionary *dic in newsinfoArray) {
                        
                        NewsInfoModel *newsInfoModel = [[NewsInfoModel alloc]init];
                        
                        [newsInfoModel setValueFromDic:dic];
                        
                        [self.newsInfoArray addObject:newsInfoModel];
                    }
                    
                    //设置新闻
                    [self.tableView reloadData];

                    
                    
                    
                    
                }else{
                    //获取数据失败
                    NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
                    
                }
                
                
                
                
            } requestFail:^(NSError *error) {
                
            }];
            
            
            //请求
            
            NSDictionary *applyRequestNewsdata = @{
                                              
                                              @"appcode":self.applyAppCode,
                                              
                                              @"method":@"WFAPPLYLIST",
                                              
                                              };
            
            
            NSDictionary *applyParameters = @{
                                                    
                                                    @"token":[LocalData getToken],
                                                    
                                                    @"requestdata":applyRequestNewsdata,
                                                    
                                                    };
            
            Network *applyAppNewsNetwork = [[Network alloc]initWithURL:self.applyAppuri parameters:applyParameters requestSuccess:^(NSData *data) {
                
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
                
                NSLog(@"xmlDoc = %@",xmlDoc);
                
                if ( [[xmlDoc objectForKey:@"statuscode"] isEqualToString:@"0"]) {
                    
                    
                    
                    NSDictionary *responsedataDic = [xmlDoc objectForKey:@"responsedata"];
                    
                    NSDictionary *applylistDic = [responsedataDic objectForKey:@"applylist"];

                    NSArray *applyArray = [applylistDic objectForKey:@"apply"];
                    
                    for (NSDictionary *dic in applyArray) {
                        
                        ApplyModel *applyModel = [[ApplyModel alloc]init];
                        
                        applyModel.applyname = dic[@"applyname"];
                        
                        applyModel.formid = dic[@"formid"];
                        
                        [self.applyArray addObject:applyModel];
                        
                    }
                    
                }else{
                    
                    NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
                    
                    NSLog(@"errorMsg = %@",errorMsg);
                }
                
            } requestFail:^(NSError *error) {
                
            }];
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSLog(@"errorMsg = %@",errorMsg);
        }
        
        
    } requestFail:^(NSError *error) {
        
        NSLog(@"失败");
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
    
//    __weak typeof(self)weakSelf = self;
    
    @weakify(self)
    
    [cell showCellWithNewsInfoModelArray:self.newsInfoArray extendappArray:self.extendappDataArray jumpNewsinfoBlock:^(NewsInfoModel *newsInfoModel) {
        
        NSLog(@"跳转到新闻详情");
        
        NewsinfoDetailsViewController *newsinfoDetailsViewController = [[NewsinfoDetailsViewController alloc]init];
        
        newsinfoDetailsViewController.newsInfoModel = newsInfoModel;
        
        [weakself.navigationController pushViewController:newsinfoDetailsViewController animated:YES];
        
    } enterExtendappBlock:^(ExtendappModel *extendappModel) {
        
        NSLog(@"跳转扩展应用");
        
        ExtendappViewController *extendappViewController = [[ExtendappViewController alloc]init];
        
        extendappViewController.extendappModel = extendappModel;
        
        [weakself.navigationController pushViewController:extendappViewController animated:YES];
        
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 160.0f;
    }else{
        
        return self.view.frame.size.height - 160.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)recordAction:(id)sender {
    
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

- (IBAction)fastApplyAction:(id)sender {
    
    //弹出列表
    NSMutableArray *titlesArray = [[NSMutableArray alloc]init];
    
    for (ApplyModel *applyModel  in self.applyArray) {
        
        
        NSString *title = applyModel.applyname;
        
        [titlesArray addObject:title];
    }
    
    [LZPopOverMenu showForSender:sender withMenu:titlesArray imageNameArray:nil doneBlock:^(NSInteger selectedIndex) {
        
    } dismissBlock:^{
        
    }];
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
        
        
        NSDictionary *data = @{
                               
                               @"formid":applyModel.formid,
                               
                               @"applyname":applyModel.applyname
                               
                               };
        
        
        NSDictionary *requestdata = @{
                                      
                                      @"appcode":self.applyAppCode,
                                      
                                      @"method":@"WFAPPLY",
                                      
                                      @"data":data
                                      
                                      };
        
        NSDictionary *parameters = @{
                                     
                                     @"token":[LocalData getToken],
                                     
                                     @"requestdata":requestdata,
                                     
                                     };
        
        
        NSString *url = [LocalData getLoginInterface];

        url = [NSString stringWithFormat:@"%@/dataapi/applydata/%@/%@?token=%@",url,self.applyAppCode,applyModel.formid,[LocalData getToken]];
        
        
        NSLog(@"url = %@",url);
        
        FastApplyViewController *fastApplyViewController = [[FastApplyViewController alloc]init];
        
        fastApplyViewController.url = url;
        
        [self.navigationController pushViewController:fastApplyViewController animated:YES];

        
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
