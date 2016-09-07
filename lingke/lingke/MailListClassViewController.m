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

static const NSInteger pagecount = 20;

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

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *headTitlesArray;

@property(nonatomic,strong)NSMutableArray *namesArray;

@end

@implementation MailListClassViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.persionModelArray = [[NSMutableArray alloc]init];
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.headTitlesArray = [[NSMutableArray alloc]init];
    
    self.namesArray = [[NSMutableArray alloc]init];
    
    self.mailListClassify = MailListClassifyForDeptname;
    
    self.title = @"通讯录";
    
    self.pagestart = 1;
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    
    
    NSArray *items = [[NSArray alloc]initWithObjects:@"按部门",@"按姓名", nil];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
    self.segmentedControl.frame = CGRectMake(0,64, self.view.frame.size.width, 30);
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.searchBar.frame.size.height+self.segmentedControl.frame.size.height+64,self.view.frame.size.width,self.view.frame.size.height - self.searchBar.frame.size.height-self.segmentedControl.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    @weakify(self)
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        weakself.pagestart = 1;
        
        [weakself requestData];
        
        [weakself handData];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        weakself.pagestart = weakself.pagestart+pagecount;
        
        [weakself requestData];
        
        [weakself handData];
    }];
    
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
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)change:(UISegmentedControl *)sender{
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:{
            
            //按部门
            self.mailListClassify = MailListClassifyForDeptname;
            
            [self handData];
        }
            
            break;
            
        case 1:{
            
            //按姓名
            self.mailListClassify = MailListClassifyForName;

            [self handData];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)requestData{
    
    if (self.pagestart == 1) {
        
        [self.persionModelArray removeAllObjects];
    }
    
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
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];

        NSLog(@"xmlDoc = %@",xmlDoc);
        
        NSDictionary *responsedata = xmlDoc[@"responsedata"];
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            //数据获取成功
            NSDictionary *persons = responsedata[@"persons"];
            
            NSArray *personArray = persons[@"person"];
            
            for (NSDictionary *dic in personArray) {
                
                PersionModel *persion = [[PersionModel alloc]init];
                
                [persion setValueFromDic:dic];
                
                [weakself.persionModelArray addObject:persion];
                
            }
            
            [weakself endRefresh];

            //处理数据
            [weakself handData];
            
        }else{
            
            [weakself endRefresh];
            
            //数据获取失败
            NSString *errorMessage = xmlDoc[@"statusmsg"];
            
        }
        
    } requestFail:^(NSError *error) {
        
        [weakself endRefresh];
        
    }];
}

- (void)endRefresh{
    
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark-处理数据
- (void)handData{
    
    [self.dataArray removeAllObjects];
    [self.headTitlesArray removeAllObjects];
    
    //分类数据
    if (self.mailListClassify == MailListClassifyForDeptname) {
        
        //部门
        for (PersionModel *persion in self.persionModelArray) {
            
            if (![self.headTitlesArray containsObject:persion.orgname]) {
                
                [self.headTitlesArray addObject:persion.orgname];
                
            }
        }
        
        for (NSString *orgname in self.headTitlesArray) {
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (PersionModel *persion in self.persionModelArray) {
                
                if ([persion.orgname isEqualToString:orgname]) {
                    
                    [array addObject:persion];
                }
            }
            
            [self.dataArray addObject:array];
            
        }
        
        [self.tableView reloadData];
        
    }else{
        
        //名字
        self.headTitlesArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
        
        [self.namesArray removeAllObjects];
        
        for (int i = 0; i<self.headTitlesArray.count; i++) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            
            [dic setObject:subArray forKey:self.headTitlesArray[i]];
            
            [self.namesArray addObject:dic];
        }
        
        
        for (int i = 0; i<self.namesArray.count; i++){
            
            NSMutableDictionary *tmpDic = self.namesArray[i];
            
            for (PersionModel *persionModel in self.persionModelArray) {
                
                NSString *key = [self firstCharactor:persionModel.username];
                
                if ([key isEqualToString:tmpDic.allKeys.lastObject]) {
                    
                    NSMutableArray *tmpArray = tmpDic[key];
                    
                    [tmpArray addObject:persionModel];
                }
            }
        }
        
        NSLog(@"array = %@",self.namesArray);
        
    }
    
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
}

//当点击search的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    //请求数据
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.mailListClassify == MailListClassifyForDeptname) {
        
        //部门
        return self.dataArray.count;

        
    }else{
        
        return self.headTitlesArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.mailListClassify == MailListClassifyForDeptname) {
        
        return ((NSMutableArray *)(self.dataArray[section])).count;
        
    }else{
        
        NSMutableDictionary *dic = self.namesArray[section];
        
        NSString *key = self.headTitlesArray[section];
        
        NSMutableArray *array = [dic objectForKey:key];
        
        return array.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCellID"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
    }
    
    if (self.mailListClassify == MailListClassifyForDeptname) {
        
        PersionModel *persion = self.dataArray[indexPath.section][indexPath.row];
        
        cell.cell1Label.text = persion.username;
        
        //    cell.cell1HeadImageView
        
    }else{
        
        NSMutableDictionary *dic = self.namesArray[indexPath.section];
        
        NSString *key = self.headTitlesArray[indexPath.section];
        
        NSMutableArray *array = [dic objectForKey:key];
        
        PersionModel *persion = array[indexPath.row];
        
        cell.cell1Label.text = persion.username;
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转到详情
    self.hidesBottomBarWhenPushed = YES;

    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MailDetailsViewController *mailDetailsViewController = [storyborad instantiateViewControllerWithIdentifier:@"MailDetailsViewController"];
    
    [self.navigationController pushViewController:mailDetailsViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MailListTableViewHeadView *headView = (MailListTableViewHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MailListTableViewHeadViewID"];
    
    if (!headView) {
        
        headView = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewHeadView" owner:self options:nil].lastObject;
    }
    
    headView.titleLabel.text = self.headTitlesArray[section];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0f;
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
