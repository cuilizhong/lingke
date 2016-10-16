//
//  MessageViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MessageViewController.h"
#import "MenusView.h"
#import "MessageModel.h"
#import "MessageTableViewCell.h"
#import "MessageDetailsViewController.h"
#import "MJRefresh.h"

#import "DataIndexViewController.h"

#import "SearchMessageViewController.h"

static const NSInteger pagecount = 20;


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *messagekindsArray;

@property(nonatomic,strong)MenusView *menusView;

@property(nonatomic,strong)NSMutableArray *messageContentsArray;

@property(nonatomic,strong)UITableView *contentTableView;

@property(nonatomic,strong)NSString *currentTitle;

@property(nonatomic,assign)NSInteger pagestart;


@property(nonatomic,strong)UILabel *tipNoDataLabel;

@property(nonatomic,assign)BOOL isSearch;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"信息";
    
    self.currentTitle = @"全部信息";
    
    self.pagestart = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.messagekindsArray = [[NSMutableArray alloc]init];
    
    self.messageContentsArray = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
    
    self.tipNoDataLabel = [[UILabel alloc]init];
    self.tipNoDataLabel.text = @"无信息";
    self.tipNoDataLabel.font = [UIFont systemFontOfSize:14];
    self.tipNoDataLabel.textColor = [UIColor darkGrayColor];
    self.tipNoDataLabel.textAlignment = NSTextAlignmentCenter;
    self.tipNoDataLabel.backgroundColor = [UIColor clearColor];
    self.tipNoDataLabel.center = self.view.center;
    self.tipNoDataLabel.frame = CGRectMake(0,self.tipNoDataLabel.frame.origin.y-60, self.view.frame.size.width, 30);
    [self.view addSubview:self.tipNoDataLabel];
    self.tipNoDataLabel.hidden = YES;
}

- (void)searchBarButtonAction:(UIBarButtonItem *)sender{
    
    self.isSearch = YES;

    SearchMessageViewController *searchMessageViewController = [[SearchMessageViewController alloc]init];
    
    searchMessageViewController.kind = self.currentTitle;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:searchMessageViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.isSearch) {
        
        //
        self.isSearch = NO;

        [self requestMessageDataWithKind:self.currentTitle];
        
    }else{
        
        [self requst];
    }
    

}

- (void)requst{
    
    [self showHUD];
    
    NSString *appcode = [HomeFunctionModel sharedInstance].messageAppModel.appcode;
    
    NSString *appuri = [HomeFunctionModel sharedInstance].messageAppModel.appuri;
    
    NSDictionary *data = @{
                           
                           @"formid":@"",
                           
                           };
    
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":appcode,
                                  
                                  @"method":@"MESSAGEKIND",
                                  
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
            
            [weakself hiddenHUD];
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *messagekindsDic = responsedataDic[@"messagekinds"];
            
            id messagekindArray = messagekindsDic[@"messagekind"];
            
            
            [weakself.messagekindsArray removeAllObjects];
            
            [weakself.messagekindsArray addObject:@"全部信息"];
            
            if ([messagekindArray isKindOfClass:[NSArray class]]) {
                
                [weakself.messagekindsArray addObjectsFromArray:messagekindArray];

            }else if ([messagekindArray isKindOfClass:[NSString class]]){
                
                [weakself.messagekindsArray addObject:messagekindArray];

            }
            
            weakself.menusView = [[MenusView alloc]initWithFrame:CGRectMake(0,0, weakself.view.frame.size.width,40) menusTitle:weakself.messagekindsArray selectedBlock:^(NSString *title) {
                
                weakself.pagestart = 1;
                
                weakself.currentTitle = title;
                
                [weakself requestMessageDataWithKind:title];
            }];
            
            [weakself.view addSubview:weakself.menusView];
            
            //crearTableView
            weakself.contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, weakself.menusView.frame.size.height, weakself.view.frame.size.width, weakself.view.frame.size.height-weakself.menusView.frame.size.height-49) style:UITableViewStylePlain];
            weakself.contentTableView.delegate = weakself;
            weakself.contentTableView.dataSource = weakself;
            [weakself hiddenSurplusLine:weakself.contentTableView];
            
            [weakself.view addSubview:weakself.contentTableView];
            
            [weakself.view bringSubviewToFront:weakself.tipNoDataLabel];
            
            weakself.contentTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                
                weakself.pagestart = 1;
                
                [weakself requestMessageDataWithKind:weakself.currentTitle];
                
            }];
            
            weakself.contentTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                
                weakself.pagestart = weakself.pagestart+pagecount;
                
                [weakself requestMessageDataWithKind:weakself.currentTitle];
                
            }];
            
            [weakself requestMessageDataWithKind:@"ALL"];
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself requst];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];

        }
 
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
        
    }];
    
}

- (void)requestMessageDataWithKind:(NSString *)kind{
    
    if ([kind isEqualToString:@"全部信息"]) {
        kind = @"ALL";
    }
    
    [self showHUD];
    
    if (self.pagestart == 1) {
        
        [self.messageContentsArray removeAllObjects];

    }
    
    NSString *appcode = [HomeFunctionModel sharedInstance].messageAppModel.appcode;
    
    NSString *appuri = [HomeFunctionModel sharedInstance].messageAppModel.appuri;
    
    NSDictionary *data = @{
                           
                           @"kind":kind,
                           
                           @"pagestart":[NSString stringWithFormat:@"%ld",(long)self.pagestart],
                           
                           @"pagecount":[NSString stringWithFormat:@"%ld",(long)pagecount],
                           
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
        
        [weakself.contentTableView.mj_footer endRefreshing];
        [weakself.contentTableView.mj_header endRefreshing];
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"信息xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSMutableDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSMutableDictionary *messagesDic = responsedataDic[@"messages"];
            
            id messageArray = messagesDic[@"message"];
            
            if ([messageArray isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in messageArray) {
                    
                    MessageModel *messageModel = [[MessageModel alloc]init];
                    
                    [messageModel setValueFromDic:dic];
                    
                    [weakself.messageContentsArray addObject:messageModel];
                }
                
                
            }else if([messageArray isKindOfClass:[NSDictionary class]]){
                
                MessageModel *messageModel = [[MessageModel alloc]init];
                
                [messageModel setValueFromDic:messageArray];
                
                [weakself.messageContentsArray addObject:messageModel];
            }
            
            
            
            [weakself.contentTableView reloadData];
            
            if (weakself.messageContentsArray.count) {
                weakself.tipNoDataLabel.hidden = YES;
            }else{
                weakself.tipNoDataLabel.hidden = NO;

            }
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself requestMessageDataWithKind:kind];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
        }
        
        
    } requestFail:^(NSError *error) {
        
        [weakself.contentTableView.mj_footer endRefreshing];
        [weakself.contentTableView.mj_header endRefreshing];
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageContentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"MessageTableViewCellID";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MessageModel *messageModel = self.messageContentsArray[indexPath.row];
    
    [cell showCellWithTitle:messageModel.title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageModel *messageModel = self.messageContentsArray[indexPath.row];
    
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
    
    MessageModel *messageModel = self.messageContentsArray[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    
    DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
    
    dataIndexViewController.title = messageModel.title;
    dataIndexViewController.url = messageModel.url;
    
    
    self.isSearch = YES;

//    MessageDetailsViewController *messageDetailsViewController = [[MessageDetailsViewController alloc]init];
//    
//    messageDetailsViewController.messageModel = messageModel;
    
    [self.navigationController pushViewController:dataIndexViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
