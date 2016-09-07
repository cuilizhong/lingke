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

@interface MailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MailListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MailListTableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].firstObject;
            
            cell.cell0Label.text = [UserinfoModel sharedInstance].unitname;
            
        }else{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCell0ID"];
            
            if (!cell) {
                
                cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
            }
            
            if (indexPath.row == 1) {
                
                cell.cell0Label.text = @"我的好友";
                
            }else if (indexPath.row == 2){
                
                cell.cell1Label.text = @"我的群住";
            
            }else if (indexPath.row == 3){
                
                cell.cell1Label.text = @"我的关注";
            }
            
        }
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCell1ID"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle]loadNibNamed:@"MailListTableViewCell" owner:self options:nil].lastObject;
        }
        
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
    
    self.hidesBottomBarWhenPushed = YES;

    MailListClassViewController *mailListClassViewController = [[MailListClassViewController alloc]init];
    
    mailListClassViewController.homeappModel = self.homeappModel;
    
    [self.navigationController pushViewController:mailListClassViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
