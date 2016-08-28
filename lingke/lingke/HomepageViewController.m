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

@interface HomepageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *homeappArray;

@property(nonatomic,strong)NSMutableArray *newsInfoArray;

@property(nonatomic,strong)NSMutableArray *extendappDataArray;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.homeappArray = [[NSMutableArray alloc]init];
    
    self.newsInfoArray = [[NSMutableArray alloc]init];
    
    self.extendappDataArray = [[NSMutableArray alloc]init];
    
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
            
            for (NSDictionary *dic in appArray) {
                
                HomeappModel *homeappModel = [[HomeappModel alloc]init];
                
                [homeappModel setValueFromDic:dic];
                
                [self.homeappArray addObject:homeappModel];
                
                if ([[dic objectForKey:@"appurikind"]isEqualToString:@"HOMENEWS"]) {
                    
                    //首页新闻
                    appcode = [dic objectForKey:@"appcode"];
                    appuri = [dic objectForKey:@"appuri"];
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
    
    [cell showCellWithNewsInfoModelArray:self.newsInfoArray extendappArray:self.extendappDataArray];
    
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
}

- (IBAction)fastApplyAction:(id)sender {
}
@end
