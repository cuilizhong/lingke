//
//  MailListViewController.m
//  lingke
//
//  Created by clz on 16/8/31.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MailListViewController.h"
#import "MailListTableViewCell.h"
#import "MailListTableViewHeadView.h"
#import "MailListClassViewController.h"
#import "AppDelegate.h"
#import "PersionModel.h"
#import "MailDetailsViewController.h"
#import "MyFriendViewController.h"

@interface MailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

/**
 *  常用联系人是查询本地的数据库的
 */
@property(nonatomic,strong)NSMutableArray *topContactsArray;


@end

@implementation MailListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    self.topContactsArray = [delegate selectAll];
    
    //
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }else{
        return self.self.topContactsArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MailListTableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].firstObject;
            
            
            
            cell.cell0Label.text = [LocalData getUnitname];
            
        }else{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCell0ID"];
            
            if (!cell) {
                
                cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
            }
            
            if (indexPath.row == 1) {
                
                cell.cell1Label.text = @"我的好友";
                
            }else if (indexPath.row == 2){
                
                cell.cell1Label.text = @"我的群组";
            
            }else if (indexPath.row == 3){
                
                cell.cell1Label.text = @"我的关注";
            }
            
        }
        
    }else{
        
        //常联系人
        cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCell1ID"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
        }
        
        PersionModel *persionModel = self.topContactsArray[indexPath.row];
        
        cell.cell1Label.text = persionModel.username;

        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MailListTableViewHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewHeadView" owner:self options:nil].lastObject;
    
    if (section == 0) {
        
        headView.titleLabel.text = @"企业通讯录";
        
    }else{
        
        headView.titleLabel.text = @"常用联系人";

    }
    
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            //企业通讯录
            self.hidesBottomBarWhenPushed = YES;
            
            MailListClassViewController *mailListClassViewController = [[MailListClassViewController alloc]init];
            
            mailListClassViewController.homeappModel = self.homeappModel;
            
            [self.navigationController pushViewController:mailListClassViewController animated:YES];
            
            self.hidesBottomBarWhenPushed = YES;
            
        }else{
            
            //我的好友、我的群组、我的关注（请求所有的数据，本地过滤）
            self.hidesBottomBarWhenPushed = YES;
            
            MyFriendViewController *myFriendViewController = [[MyFriendViewController alloc]init];
            if (indexPath.row == 1) {
                //我的好友
                myFriendViewController.mailListState = MailListState_Friend;
                
            }else if (indexPath.row == 2){
                //我的群组
                myFriendViewController.mailListState = MailListState_Grounp;

            
            }else if (indexPath.row == 3){
                //我的关注
                myFriendViewController.mailListState = MailListState_Follow;

            }
            
            myFriendViewController.homeappModel = self.homeappModel;
            
            [self.navigationController pushViewController:myFriendViewController animated:YES];
            
            self.hidesBottomBarWhenPushed = YES;
        }
        
    }else if (indexPath.section == 1){
        
        //常用联系人
        self.hidesBottomBarWhenPushed = YES;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MailDetailsViewController *mailDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MailDetailsViewController"];;
        
        mailDetailsViewController.persion = self.topContactsArray[indexPath.row];
        
        mailDetailsViewController.homeappModel = self.homeappModel;
        
        mailDetailsViewController.isLocal = YES;
        
        [self.navigationController pushViewController:mailDetailsViewController animated:YES];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
