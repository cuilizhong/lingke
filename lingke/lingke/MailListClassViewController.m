//
//  MailListClassViewController.m
//  lingke
//
//  Created by clz on 16/9/1.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MailListClassViewController.h"
#import "MailListTableViewCell.h"
#import "MailListTableViewHeadView.h"
#import "PersionModel.h"
#import "MJRefresh.h"
#import "MailDetailsViewController.h"
#import "UIImageView+WebCache.h"


static const NSInteger pagecount = 1000;

typedef NS_ENUM(NSInteger, MailListClassify)
{
    MailListClassifyForName,
    
    MailListClassifyForDeptname
    
};

@interface MailListClassViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)UISegmentedControl *segmentedControl;

/**
 *  开始
 */
@property(nonatomic,assign)NSInteger pagestart;

@property(nonatomic,strong)NSMutableArray *persionModelArray;

@property(nonatomic,assign)MailListClassify mailListClassify;

@property(nonatomic,strong)NSMutableArray *headTitleForDeptnameArray;
@property(nonatomic,strong)NSMutableArray *classifyForDeptnameArray;

@property(nonatomic,strong)NSMutableArray *headTitleForNameArray;
@property(nonatomic,strong)NSMutableArray *classifyForNameArray;


@property(nonatomic,strong)UITableView *searchTableView;

@property(nonatomic,strong)NSMutableArray *searchArray;

@end

@implementation MailListClassViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headTitleForDeptnameArray = [[NSMutableArray alloc]init];
    self.classifyForDeptnameArray = [[NSMutableArray alloc]init];
    
    self.headTitleForNameArray = [[NSMutableArray alloc]init];
    self.classifyForNameArray = [[NSMutableArray alloc]init];

    
    self.persionModelArray = [[NSMutableArray alloc]init];
    
    self.searchArray = [[NSMutableArray alloc]init];

    
    self.mailListClassify = MailListClassifyForDeptname;
    
    self.title = @"通讯录";
    
    self.pagestart = 1;
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    
    
    NSArray *items = [[NSArray alloc]initWithObjects:@"按部门",@"按姓名", nil];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
    self.segmentedControl.frame = CGRectMake(0,0, self.view.frame.size.width, 30);
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];

    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.segmentedControl.frame.size.height+self.segmentedControl.frame.origin.y, self.view.frame.size.width, 40)];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.searchBar.frame.size.height+self.segmentedControl.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - self.searchBar.frame.size.height-self.segmentedControl.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.searchBar.frame.size.height+self.segmentedControl.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - self.searchBar.frame.size.height-self.segmentedControl.frame.size.height-64) style:UITableViewStylePlain];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    [self.view addSubview:self.searchTableView];
    
    self.searchTableView.hidden = YES;
    
    @weakify(self)
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [weakself requestMailList];
        
    }];
    
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        
//        weakself.pagestart = weakself.pagestart+pagecount;
//        
//        [weakself requestData];
//        
//        [weakself handData];
//    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)addAction:(UIBarButtonItem *)sender{
    
    self.hidesBottomBarWhenPushed = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MailDetailsViewController *mailDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MailDetailsViewController"];
    
    mailDetailsViewController.isEdit = YES;
    
    mailDetailsViewController.homeappModel = self.homeappModel;
    
    [self.navigationController pushViewController:mailDetailsViewController animated:YES];

    self.hidesBottomBarWhenPushed = YES;

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)change:(UISegmentedControl *)sender{
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:{
            
            //按部门
            self.mailListClassify = MailListClassifyForDeptname;
            
            [self.tableView reloadData];
            
        }
            
            break;
            
        case 1:{
            
            //按姓名
            self.mailListClassify = MailListClassifyForName;
            
            [self.tableView reloadData];


        }
            
            break;
            
        default:
            break;
    }
}

- (void)requestMailList{
    
    [self showHUDWithMessage:@"加载中，请稍后"];
    
    
    NSDictionary *data = @{
                           
                           @"pagestart":[NSString stringWithFormat:@"%ld",(long)self.pagestart],
                           
                           @"pagecount":[NSString stringWithFormat:@"%ld",pagecount],
                           
                           @"kind":@"ALL"
                           
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
        
        
        [weakself endRefresh];
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];

        NSLog(@"xmlDoc = %@",xmlDoc);
        
        NSDictionary *responsedata = xmlDoc[@"responsedata"];
        
        NSString *statuscode = xmlDoc[@"statuscode"];
        
        if ([statuscode isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];

            
            //数据获取成功
            NSDictionary *persons = responsedata[@"persons"];
            
            NSArray *personArray = persons[@"person"];
            
            for (NSDictionary *dic in personArray) {
                
                PersionModel *persion = [[PersionModel alloc]init];
                
                [persion setValueFromDic:dic];
                
                [weakself.persionModelArray addObject:persion];
                
            }
            

            //处理数据
            [weakself handData];
            
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
        
        [weakself endRefresh];
        
        [weakself showHUDWithMessage:RequestFailureMessage];

        
    }];
}

- (void)endRefresh{
    
    [self.tableView.mj_header endRefreshing];
    
//    [self.tableView.mj_footer endRefreshing];
}

#pragma mark-处理数据(按部门，按姓名)
- (void)handData{
    
    [self.headTitleForDeptnameArray removeAllObjects];
    
    [self.classifyForDeptnameArray removeAllObjects];

    
    [self.headTitleForNameArray removeAllObjects];
    
    [self.classifyForNameArray removeAllObjects];
    
#pragma mark-按部分类
    
    //遍历获取部门
    for (PersionModel *persion in self.persionModelArray) {
        
        if (![self.headTitleForDeptnameArray containsObject:persion.orgname]) {
            
            [self.headTitleForDeptnameArray addObject:persion.orgname];
            
        }
    }
    
    //分类
    for (NSString *orgname in self.headTitleForDeptnameArray) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (PersionModel *persion in self.persionModelArray) {
            
            if ([persion.orgname isEqualToString:orgname]) {
                
                [array addObject:persion];
            }
        }
        
        [self.classifyForDeptnameArray addObject:array];
    }
    
    
#pragma mark-按首字母分类
    //名字
    self.headTitleForNameArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    //先创建空的
    for (int i = 0; i<self.headTitleForNameArray.count; i++) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *subArray = [[NSMutableArray alloc]init];
        
        [dic setObject:subArray forKey:self.headTitleForNameArray[i]];
        
        [self.classifyForNameArray addObject:dic];
    }
    
    //添加数据到每组里面
    for (int i = 0; i<self.classifyForNameArray.count; i++){
        
        NSMutableDictionary *tmpDic = self.classifyForNameArray[i];
        
        for (PersionModel *persionModel in self.persionModelArray) {
            
            NSString *key = [self firstCharactor:persionModel.username];
            
            if ([key isEqualToString:tmpDic.allKeys.lastObject]) {
                
                NSMutableArray *tmpArray = tmpDic[key];
                
                [tmpArray addObject:persionModel];
            }
        }
    }
    
    //删除空组
    NSMutableArray *tmpHeadTitleForNameArray = [[NSMutableArray alloc]init];
    NSMutableArray *tmpClassifyForNameArray = [[NSMutableArray alloc]init];
    
    for (NSString *title in self.headTitleForNameArray) {
        
        for (NSDictionary *dic in self.classifyForNameArray) {
            
            if ([title isEqualToString:dic.allKeys.lastObject]) {
                
                NSMutableArray *tmpArray = dic[title];
                
                if (tmpArray.count<1) {
                    
                    [tmpHeadTitleForNameArray addObject:title];
                    
                    [tmpClassifyForNameArray addObject:dic];
                }
                
            }
        }
    }
    
    [self.headTitleForNameArray removeObjectsInArray:tmpHeadTitleForNameArray];
    [self.classifyForNameArray removeObjectsInArray:tmpClassifyForNameArray];
    
    
    [self.tableView reloadData];
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
    
    self.searchTableView.hidden = YES;
    self.tableView.hidden = NO;
}

//当点击search的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    [self.searchArray removeAllObjects];
    
    for (PersionModel *persion in self.persionModelArray) {
        
        if ([persion.username containsString:searchBar.text]) {
            
            [self.searchArray addObject:persion];
        }
        
    }
    
    self.searchTableView.hidden = NO;
    self.tableView.hidden = YES;
    [self.searchTableView reloadData];
    
    
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.tableView == tableView) {
        
        if (self.mailListClassify == MailListClassifyForDeptname) {
            
            //部门
            return self.headTitleForDeptnameArray.count;
            
            
        }else{
            
            return self.headTitleForNameArray.count;
        }

    }else{
        
        return 1;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.tableView == tableView) {
        
        if (self.mailListClassify == MailListClassifyForDeptname) {
            
            return ((NSMutableArray *)(self.classifyForDeptnameArray[section])).count;
            
        }else{
            
            NSMutableDictionary *dic = self.classifyForNameArray[section];
            
            NSString *key = self.headTitleForNameArray[section];
            
            NSMutableArray *array = [dic objectForKey:key];
            
            return array.count;
        }
    }else{
        
        return self.searchArray.count;
    }
    
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCellID"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
    }
    
    if (self.tableView == tableView) {
        
        if (self.mailListClassify == MailListClassifyForDeptname) {
            
            PersionModel *persion = self.classifyForDeptnameArray[indexPath.section][indexPath.row];
            
            cell.cell1Label.text = persion.username;
            
            [cell.cell1HeadImageView sd_setImageWithURL:[NSURL URLWithString:persion.headurl] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
            
        }else{
            
            NSMutableDictionary *dic = self.classifyForNameArray[indexPath.section];
            
            NSString *key = self.headTitleForNameArray[indexPath.section];
            
            NSMutableArray *array = [dic objectForKey:key];
            
            PersionModel *persion = array[indexPath.row];
            
            cell.cell1Label.text = persion.username;
        }
        
    }else{
        
        PersionModel *persion = self.searchArray[indexPath.row];
        
        cell.cell1Label.text = persion.username;
        
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersionModel *persion;
    
    if (self.tableView == tableView) {
        
        if (self.mailListClassify == MailListClassifyForDeptname) {
            
            NSMutableArray *array = self.classifyForDeptnameArray[indexPath.section];
            
            persion = array[indexPath.row];
            
        }else{
            
            NSMutableDictionary *dic = self.classifyForNameArray[indexPath.row];
            NSString *key = self.headTitleForNameArray[indexPath.row];
            NSMutableArray *array = dic[key];
            
            persion = array[indexPath.row];
        }
    
    }else{
        
        persion = self.searchArray[indexPath.row];
        
    }

    
    //跳转到详情
    self.hidesBottomBarWhenPushed = YES;

    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MailDetailsViewController *mailDetailsViewController = [storyborad instantiateViewControllerWithIdentifier:@"MailDetailsViewController"];
    
    mailDetailsViewController.persion = persion;
    
    mailDetailsViewController.homeappModel = self.homeappModel;
    
    
    [self.navigationController pushViewController:mailDetailsViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.tableView == tableView) {
        
        MailListTableViewHeadView *headView = (MailListTableViewHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MailListTableViewHeadViewID"];
        
        if (!headView) {
            
            headView = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewHeadView" owner:self options:nil].lastObject;
        }
        
        if (self.mailListClassify == MailListClassifyForDeptname) {
            
            headView.titleLabel.text = self.headTitleForDeptnameArray[section];
            
        }else{
            
            headView.titleLabel.text = self.headTitleForNameArray[section];
            
            
        }
        
        
        return headView;
    }else{
        
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.tableView == tableView) {
        
        return 30.0f;
    }else{
        
        return 0.01f;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}



@end
