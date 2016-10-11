//
//  SearchMessageViewController.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchMessageViewController.h"
#import "MJRefresh.h"
#import "MessageModel.h"
#import "DataIndexViewController.h"
#import "MessageTableViewCell.h"

static const NSInteger pagecount = 20;

@interface SearchMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger pagestart;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation SearchMessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"搜索";
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.pagestart = 1;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    for(id view in [self.searchBar.subviews[0] subviews]){
        
        if([view isKindOfClass:[UIButton class]]){
            
            UIButton *btn = (UIButton *)view;
            
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    self.searchBar.placeholder=@"搜索";
    
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.searchBar.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - self.searchBar.frame.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self hiddenSurplusLine:self.tableView];

    @weakify(self)
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        weakself.pagestart = 1;
        
        [weakself requestData];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{

        weakself.pagestart = weakself.pagestart+pagecount;

        [weakself requestData];
        
    }];
}

- (void)requestData{
    
    if ([self.kind isEqualToString:@"全部信息"]) {
        self.kind = @"ALL";
    }
    
    [self showHUD];
    
    if (self.pagestart == 1) {
        
        [self.dataArray removeAllObjects];

    }
    
    
    NSString *appcode = [HomeFunctionModel sharedInstance].messageAppModel.appcode;
    
    NSString *appuri = [HomeFunctionModel sharedInstance].messageAppModel.appuri;
    
    NSDictionary *data = @{
                           
                           @"kind":self.kind,
                           
                           @"pagestart":[NSString stringWithFormat:@"%ld",(long)self.pagestart],
                           
                           @"pagecount":[NSString stringWithFormat:@"%ld",(long)pagecount],
                           
                           @"search":self.searchBar.text
                           
                           };
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":appcode,
                                  
                                  @"method":@"MESSAGELIST",
                                  
                                  @"data":data
                                  
                                  };
    
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    @weakify(self);
    [HttpsRequestManger sendHttpReqestWithUrl:appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"信息xmlDoc = %@",xmlDoc);
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSMutableDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSMutableDictionary *messagesDic = responsedataDic[@"messages"];
            
            id messageArray = messagesDic[@"message"];
            
            if ([messageArray isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in messageArray) {
                    
                    MessageModel *messageModel = [[MessageModel alloc]init];
                    
                    [messageModel setValueFromDic:dic];
                    
                    [weakself.dataArray addObject:messageModel];
                }
                
            }else if ([messageArray isKindOfClass:[NSDictionary class]]){
                
                MessageModel *messageModel = [[MessageModel alloc]init];
                
                [messageModel setValueFromDic:messageArray];
                
                [weakself.dataArray addObject:messageModel];

            }
                        
            [weakself.tableView reloadData];
            
        }else{
            
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            [weakself hiddenHUDWithMessage:errorMessage];
            
            NSLog(@"errorMessage = %@",errorMessage);
        }
        
        
    } requestFail:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
    }];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-UISearchBarDelegate
//任务编辑文本
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}

//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
  
}

//当点击search的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"MessageTableViewCellID";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MessageModel *messageModel = self.dataArray[indexPath.row];
    
    [cell showCellWithTitle:messageModel.title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageModel *messageModel = self.dataArray[indexPath.row];
    
    NSString *title = messageModel.title;
    
    CGFloat titleLabelLeft = 10;
    
    CGFloat titleLabelRight = 30;
    
    CGFloat titleLabelWidth = self.view.frame.size.width - titleLabelLeft - titleLabelRight;
    
    CGFloat titleLabelHeight;
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:title attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(titleLabelWidth, MAXFLOAT);
    
    CGRect detailRect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    titleLabelHeight = detailRect.size.height;
    
    
    return titleLabelHeight+20;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageModel *messageModel = self.dataArray[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    
    DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
    
    dataIndexViewController.title = messageModel.title;
    dataIndexViewController.url = messageModel.url;
    
    [self.navigationController pushViewController:dataIndexViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
