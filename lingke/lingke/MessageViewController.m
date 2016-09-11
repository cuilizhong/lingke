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

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *messagekindsArray;

@property(nonatomic,strong)MenusView *menusView;

@property(nonatomic,strong)NSMutableArray *messageContentsArray;

@property(nonatomic,strong)UITableView *contentTableView;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"信息";
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.messagekindsArray = [[NSMutableArray alloc]init];
    
    self.messageContentsArray = [[NSMutableArray alloc]init];
    
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
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *messagekindsDic = responsedataDic[@"messagekinds"];
            
            NSArray *messagekindArray = messagekindsDic[@"messagekind"];
            
            [weakself.messagekindsArray addObject:@"全部信息"];
            
            [weakself.messagekindsArray addObjectsFromArray:messagekindArray];
            
            weakself.menusView = [[MenusView alloc]initWithFrame:CGRectMake(0,64, weakself.view.frame.size.width,40) menusTitle:weakself.messagekindsArray selectedBlock:^(NSString *title) {
                
                [weakself requestMessageDataWithKind:title];
            }];
            
            [weakself.view addSubview:self.menusView];
            
            //crearTableView
            self.contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, weakself.menusView.frame.size.height+64, self.view.frame.size.width, self.view.frame.size.height-weakself.menusView.frame.size.height - 64-49) style:UITableViewStylePlain];
            self.contentTableView.delegate = self;
            self.contentTableView.dataSource = self;
            [self.view addSubview:self.contentTableView];
            
            [weakself requestMessageDataWithKind:@"ALL"];
            
        }else{
            
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            NSLog(@"errorMessage = %@",errorMessage);
        }
        
        
        
        
    } requestFail:^(NSError *error) {
        
    }];

}

- (void)requestMessageDataWithKind:(NSString *)kind{
    
    [self.messageContentsArray removeAllObjects];
    
    NSString *appcode = [HomeFunctionModel sharedInstance].messageAppModel.appcode;
    
    NSString *appuri = [HomeFunctionModel sharedInstance].messageAppModel.appuri;
    
    NSDictionary *data = @{
                           
                           @"kind":kind,
                           
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
    
    [HttpsRequestManger sendHttpReqestWithUrl:appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"信息xmlDoc = %@",xmlDoc);
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            NSMutableDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSMutableDictionary *messagesDic = responsedataDic[@"messages"];
            
            NSArray *messageArray = messagesDic[@"message"];
            
            for (NSDictionary *dic in messageArray) {
                
                MessageModel *messageModel = [[MessageModel alloc]init];
                
                [messageModel setValueFromDic:dic];
                
                [self.messageContentsArray addObject:messageModel];
            }
            
            [self.contentTableView reloadData];

        }else{
            
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
            NSLog(@"errorMessage = %@",errorMessage);
        }
        
        
    } requestFail:^(NSError *error) {
        
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
    
    MessageDetailsViewController *messageDetailsViewController = [[MessageDetailsViewController alloc]init];
    
    messageDetailsViewController.messageModel = messageModel;
    
    [self.navigationController pushViewController:messageDetailsViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end