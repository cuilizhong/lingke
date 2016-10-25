//
//  SearchExtendAppSubViewController.m
//  lingke
//
//  Created by clz on 16/10/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendAppSubViewController.h"
#import "SearchfieldModel.h"
#import "SearchExtendappCell.h"
#import "SearchExtendAppSubChooseDateView.h"

@interface SearchExtendAppSubViewController ()


@property(nonatomic,strong)NSMutableArray *searchDataArray;

@end

@implementation SearchExtendAppSubViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.dataArray = [[NSMutableArray alloc]init];
    
    [self hiddenSurplusLine:self.tableView];
    
}

- (void)leftButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self request];
    
}

- (void)request{
    
    [self showHUD];
    
    NSDictionary *dataDic = @{
                              
                              @"formid":self.appmenuModel.formid,
                              
                              };
    
    NSDictionary *requestNewsdata = @{
                                      
                                      @"appcode":self.extendappModel.appcode,
                                      
                                      @"method":@"SEARCHFORM",
                                      
                                      @"data":dataDic
                                      
                                      };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestNewsdata,
                                 
                                 };
    
    @weakify(self);
    [HttpsRequestManger sendHttpReqestWithUrl:self.appmenuModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"]isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *searchfieldsDic = responsedataDic[@"searchfields"];
            
            id searchfieldsArray = searchfieldsDic[@"searchfield"];
            
            [weakself.dataArray removeAllObjects];
            
            if ([searchfieldsArray isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in searchfieldsArray) {
                    
                    SearchfieldModel *searchfieldModel = [[SearchfieldModel alloc]init];
                    
                    [searchfieldModel setValueFromDic:dic];
                    
                    [weakself.dataArray addObject:searchfieldModel];
                    
                }
                
            }else if ([searchfieldsArray isKindOfClass:[NSDictionary class]]){
                
                SearchfieldModel *searchfieldModel = [[SearchfieldModel alloc]init];
                
                [searchfieldModel setValueFromDic:searchfieldsArray];
                
                [weakself.dataArray addObject:searchfieldModel];
            }
            
            [weakself.tableView reloadData];
            
        }else{
            
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself request];
                
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
            
            
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
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"SearchExtendappCellID";
    
    SearchExtendappCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"SearchExtendappCell" owner:self options:nil].firstObject;
    }
    
    SearchfieldModel *searchfieldModel = self.dataArray[indexPath.row];
    
    [cell showCellWithFieldname:searchfieldModel.fieldlabel fieldtype:searchfieldModel.fieldtype fieldvalue:searchfieldModel.fieldvalue  selectedDateBlock:^{
        //弹出选择时间
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        SearchExtendAppSubChooseDateView *searchExtendAppSubChooseDateView = [[NSBundle mainBundle]loadNibNamed:@"SearchExtendAppSubChooseDateView" owner:self options:nil].firstObject;
        
        [searchExtendAppSubChooseDateView showViewWithDoneBlock:^(NSString *dateStr) {
            
            NSLog(@"dateStr = %@",dateStr);
            
            searchfieldModel.fieldvalue = dateStr;
            
            //刷新这个cell
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
        searchExtendAppSubChooseDateView.frame = CGRectMake(0, 0, window.frame.size.width,window.frame.size.height);
        
        [window addSubview:searchExtendAppSubChooseDateView];
        
    }cellEditEndBlock:^(NSString *text){
        
        searchfieldModel.fieldvalue = text;

        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

    
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}
@end
