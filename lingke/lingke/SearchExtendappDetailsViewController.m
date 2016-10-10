//
//  SearchExtendappDetailsViewController.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendappDetailsViewController.h"
#import "AppurikindTableViewCell.h"
#import "SearchDataindexModel.h"
#import "DataIndexViewController.h"
#import "SearchfieldModel.h"
#import "GDataXMLNode.h"
#import "MJRefresh.h"



static const NSInteger pagecount = 20;


@interface SearchExtendappDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger pagestart;


@end

@implementation SearchExtendappDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    
    self.searchDataArray = [[NSMutableArray alloc]init];
    
    self.pagestart = 1;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        weakself.pagestart = 1;
        
        [weakself searchRequest];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        weakself.pagestart = weakself.pagestart+pagecount;
        
        [weakself searchRequest];
        
    }];
    
    [self hiddenSurplusLine:self.tableView];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self searchRequest];
}


- (void)searchRequest{
    
    [self showHUD];
    
    NSMutableArray *searchfields = [[NSMutableArray alloc]init];
    
    for (SearchfieldModel *searchfieldModel in self.dataArray) {
        
        NSDictionary *searchfieldDic = @{
                                         
                                         @"fieldname":searchfieldModel.fieldname,
                                         
                                         @"fieldvalue":searchfieldModel.fieldvalue.length>0?searchfieldModel.fieldvalue:@""
                                         
                                         };
        
        [searchfields addObject:searchfieldDic];
        
    }
    
    //请求
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"maps"];
    
    GDataXMLElement *tokenElement = [GDataXMLNode elementWithName:@"token" stringValue:[LocalData getToken]];
    
    GDataXMLElement *requestdataElement = [GDataXMLNode elementWithName:@"requestdata"];
    
    GDataXMLElement *appcodeElement = [GDataXMLNode elementWithName:@"appcode" stringValue:self.extendappModel.appcode];
    
    GDataXMLElement *methodElement = [GDataXMLNode elementWithName:@"method" stringValue:[NSString stringWithFormat:@"%@LIST",self.appmenuModel.appurikind]];
    GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"data"];
    
    [requestdataElement addChild:appcodeElement];
    [requestdataElement addChild:methodElement];
    
    
    GDataXMLElement *formidElement = [GDataXMLNode elementWithName:@"formid" stringValue:self.appmenuModel.formid];
    
    
    GDataXMLElement *pagestartElement = [GDataXMLNode elementWithName:@"pagestart" stringValue:[NSString stringWithFormat:@"%ld",(long)self.pagestart]];
    GDataXMLElement *pagecountElement = [GDataXMLNode elementWithName:@"pagecount" stringValue:[NSString stringWithFormat:@"%ld",(long)pagecount]];
    GDataXMLElement *searchfieldsElement = [GDataXMLNode elementWithName:@"searchfields"];
    
    [dataElement addChild:formidElement];
    [dataElement addChild:pagestartElement];
    [dataElement addChild:pagecountElement];
    
    
    for (NSDictionary *dic in searchfields) {
        
        GDataXMLElement *searchfieldElement = [GDataXMLNode elementWithName:@"searchfield"];
        
        GDataXMLElement *fieldnameElement = [GDataXMLNode elementWithName:@"fieldname" stringValue:dic[@"fieldname"]];
        
        GDataXMLElement *fieldvalueElement = [GDataXMLNode elementWithName:@"fieldvalue" stringValue:dic[@"fieldvalue"]];
        
        [searchfieldElement addChild:fieldnameElement];
        
        [searchfieldElement addChild:fieldvalueElement];
        
        [searchfieldsElement addChild:searchfieldElement];
        
    }
    
    [dataElement addChild:searchfieldsElement];
    
    [requestdataElement addChild:dataElement];
    
    
    
    [rootElement addChild:tokenElement];
    
    [rootElement addChild:requestdataElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    
    NSData *data =  [document XMLData];
    
    NSString *xmlStr = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"请求的参数 = %@",xmlStr);
    
    @weakify(self);
    
    [[Network alloc]initWithURL:self.appmenuModel.appuri requestData:data requestSuccess:^(NSData *data) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"]isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *dataindexsDic = responsedataDic[@"dataindexs"];
            
            NSArray *dataindexsArray = dataindexsDic[@"dataindex"];
            
            if (weakself.pagestart == 1) {
                
                [weakself.searchDataArray removeAllObjects];

            }
            
            for (NSDictionary *dic in dataindexsArray) {
                
                SearchDataindexModel *searchDataindexModel = [[SearchDataindexModel alloc]init];
                
                [searchDataindexModel setValueFromDic:dic];
                
                [weakself.searchDataArray addObject:searchDataindexModel];
                
            }
            
            [weakself.tableView reloadData];
            
        }else if([xmlDoc[@"statuscode"] isEqualToString:TokenInvalidCode]){
            
            [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:^{
                
                [weakself searchRequest];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
            
            
        }else{
            
            [weakself hiddenHUDWithMessage:xmlDoc[@"statusmsg"]];
            
        }
        
        
    } requestFail:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
    }];
}

- (void)leftButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppurikindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppurikindTableViewCell"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"AppurikindTableViewCell" owner:self options:nil].lastObject;
    }
    
    SearchDataindexModel *searchDataindexModel = self.searchDataArray[indexPath.row];
    
    cell.titleLabel.text = searchDataindexModel.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    SearchDataindexModel *searchDataindexModel = self.searchDataArray[indexPath.row];
    
    DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
    
    dataIndexViewController.title = searchDataindexModel.title;
    
    dataIndexViewController.url = searchDataindexModel.openurl;
    
    [self.navigationController pushViewController:dataIndexViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
