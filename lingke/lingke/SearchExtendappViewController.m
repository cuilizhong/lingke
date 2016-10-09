//
//  SearchExtendappViewController.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendappViewController.h"
#import "SearchExtendappCell.h"
#import "SearchfieldModel.h"
#import "GDataXMLNode.h"
#import "SearchDataindexModel.h"
#import "SearchExtendappDetailsViewController.h"


@interface SearchExtendappViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *searchDataArray;


@end

@implementation SearchExtendappViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"搜索";
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.searchDataArray = [[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self hiddenSurplusLine:self.tableView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *startSearchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"开始搜索" style:UIBarButtonItemStylePlain target:self action:@selector(startSearchAction:)];
    self.navigationItem.rightBarButtonItem = startSearchBarButton;
}

- (void)leftButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startSearchAction:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    //都没填写的话fieldvalue 传空的
    
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
    GDataXMLElement *pagestartElement = [GDataXMLNode elementWithName:@"pagestart" stringValue:@"1"];
    GDataXMLElement *pagecountElement = [GDataXMLNode elementWithName:@"pagecount" stringValue:@"10"];
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
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"]isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *dataindexsDic = responsedataDic[@"dataindexs"];
            
            NSArray *dataindexsArray = dataindexsDic[@"dataindex"];
            
            [weakself.searchDataArray removeAllObjects];
            
            for (NSDictionary *dic in dataindexsArray) {
                
                SearchDataindexModel *searchDataindexModel = [[SearchDataindexModel alloc]init];
                
                [searchDataindexModel setValueFromDic:dic];
                
                [weakself.searchDataArray addObject:searchDataindexModel];
                
            }
            
            //
            SearchExtendappDetailsViewController *searchExtendappDetailsViewController = [[SearchExtendappDetailsViewController alloc]init];
            
            searchExtendappDetailsViewController.searchDataArray = self.searchDataArray;
            
            [weakself.navigationController pushViewController:searchExtendappDetailsViewController animated:NO];
            
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
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];

    }];
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
            
            NSArray *searchfieldsArray = searchfieldsDic[@"searchfield"];
            
            [weakself.dataArray removeAllObjects];
            
            for (NSDictionary *dic in searchfieldsArray) {
                
                SearchfieldModel *searchfieldModel = [[SearchfieldModel alloc]init];
                
                [searchfieldModel setValueFromDic:dic];
                
                [weakself.dataArray addObject:searchfieldModel];
                
            }
            
            [weakself.tableView reloadData];
            
        }else if([xmlDoc[@"statuscode"] isEqualToString:TokenInvalidCode]){
            
            [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:^{
                
                [weakself request];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
            
        }else{
            
            [weakself hiddenHUDWithMessage:xmlDoc[@"statusmsg"]];
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
    
    cell.fieldnameLabel.text = searchfieldModel.fieldlabel;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}




@end
