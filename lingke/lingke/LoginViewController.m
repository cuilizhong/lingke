//
//  LoginViewController.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "UIScrollView+TouchEvent.h"
#import "MainTabBarController.h"
#import "Network.h"
#import "HttpInterface.h"
#import "GDataXMLNode.h"
#import "LocalData.h"
#import "GDataXMLNode.h"
#import "ConfigureColor.h"



@interface LoginViewController()

@property(nonatomic,strong)UITextField *phoneNumberTextField;

@property(nonatomic,strong)UITextField *passwordTextField;

@property(nonatomic,strong)UITextField *unitcodeTextField;

@end


@implementation LoginViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.scrollEnabled = NO;
    
//    CGRect rect = [[self view] bounds];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
//    [imageView setImage:[UIImage imageNamed:@"image_1"]];
//    
//    self.tableView.opaque = NO;3f94d7
//    self.tableView.backgroundView = imageView;
    
    self.tableView.backgroundColor = [ConfigureColor sharedInstance].loginColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoginTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"LoginTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
    
    if (indexPath.row == 4) {
        
        @weakify(self);
        
        [cell showCellWithEntrySystemBlock:^{
            
            [weakself requestForLogin];
            
            
        }];
    }
    
    if (indexPath.row == 1) {
        
        self.unitcodeTextField = cell.unitcodeTextField;
        
        self.unitcodeTextField.text = @"LKTEST01";

    }else if (indexPath.row == 2){
        
        self.phoneNumberTextField = cell.phoneNumberTextField;
        
        self.phoneNumberTextField.text = @"13961893758";

    }else if (indexPath.row == 3){
        
        self.passwordTextField = cell.passwordTextField;
        
        self.passwordTextField.text = @"1234";
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return (self.view.frame.size.height-165)/2.0 - 50;
        
    }else if (indexPath.row == 1){
        
        return 55.0f;
    
    }else if (indexPath.row == 2){
        
        return 55.0f;
        
    }else if (indexPath.row == 3){
        
        return 55.0f;
        
    }else{
        
        return (self.view.frame.size.height-165)/2.0 + 50;

    }
}


#pragma mark-request
- (void)requestForLogin{
    
    //先验证->登陆
    
    [self showHUDWithMessage:@"登陆中"];
    
    if (self.unitcodeTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请输入您单位许可证"];
        
        
        return;
    }
    
    if (self.phoneNumberTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请输入您的手机号码"];
        
        return;
    }
    
    if (self.passwordTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请输入您的密码"];

        return;
    }
    
    NSDictionary *parameters = @{
                                 
                                 @"unitcode":self.unitcodeTextField.text,
                                 
                                 @"mobile":self.phoneNumberTextField.text
                                 
                                 };
    
    @weakify(self);
    Network *verificationNetwork = [[Network alloc]initWithURL:verificationURL parameters:parameters requestSuccess:^(NSData *data) {
        
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *serverinfoDic = responsedataDic[@"serverinfo"];
            
            NSDictionary *unitinfoDic = responsedataDic[@"unitinfo"];
            
            /*
             unitcode = LJTEST01;
             unitname = "\U7eff\U5efa\U79fb\U52a8\U5f00\U53d1";
             */
            
            NSString *iphost = serverinfoDic[@"iphost"];
            
            NSString *ssl = serverinfoDic[@"ssl"];
            
            NSString *path = serverinfoDic[@"path"];
            
            NSString *port = serverinfoDic[@"port"];
            
            NSString *loginInterface = [NSString stringWithFormat:@"%@://%@:%@%@",[ssl isEqualToString:@"no"]?@"http":@"https",iphost,port,path];
            
            //保存接口
            [LocalData setLoginInterface:loginInterface];
            
            //开始登陆
            NSDictionary *loginParameters = @{
                                              
                                              @"unitcode":self.unitcodeTextField.text,
                                              
                                              @"mobile":self.phoneNumberTextField.text,
                                              
                                              @"password":self.passwordTextField.text,
                                              
                                              @"clientos":@"ios",
                                              
                                              @"clientversion":[NSString stringWithFormat:@"ios%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]],
                                              
                                              @"clientid":[self getDeviceId]
                                              
                                              };
            
            Network *loginNetwork = [[Network alloc]initWithURL:[NSString stringWithFormat:@"%@%@",loginInterface,loginURL] parameters:loginParameters requestSuccess:^(NSData *data) {
                
                NSDictionary *loginXmlDoc = [NSDictionary dictionaryWithXMLData:data];
                
                if ([[loginXmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
                    
                    NSDictionary *loginResponsedataDic = loginXmlDoc[@"responsedata"];
                    
                    //把登陆的数据全部保存到本地
                    NSDictionary *appcenterDic = loginResponsedataDic[@"appcenter"];
                    NSDictionary *personinfoDic = loginResponsedataDic[@"personinfo"];
                    NSDictionary *sessioninfoDic = loginResponsedataDic[@"sessioninfo"];
                    NSDictionary *unitinfoDic = loginResponsedataDic[@"unitinfo"];
                    
                    
                    NSString *appcenter = appcenterDic[@"uri"];
                    
                    NSString *gender = personinfoDic[@"gender"];
                    NSString *mobile = personinfoDic[@"mobile"];
                    NSString *password = weakself.passwordTextField.text;
                    NSString *username = personinfoDic[@"username"];
                    
                    NSString *expiresin = sessioninfoDic[@"expiresin"];
                    NSString *token = sessioninfoDic[@"token"];
                    
                    NSString *customerlogo = unitinfoDic[@"customerlogo"];
                    NSString *unitcode = unitinfoDic[@"unitcode"];
                    NSString *unitname = unitinfoDic[@"unitname"];
                    NSString *updatetime = unitinfoDic[@"updatetime"];
                    
                    [LocalData setAppcenter:appcenter];
                    [LocalData setMobile:mobile];
                    [LocalData setGender:gender];
                    [LocalData setPassword:password];
                    [LocalData setUsername:username];
                    [LocalData setExpiresin:expiresin];
                    [LocalData setToken:token];
                    [LocalData setCustomerlogo:customerlogo];
                    [LocalData setUnitcode:unitcode];
                    [LocalData setUnitname:unitname];
                    [LocalData setUpdatetime:updatetime];

                    [weakself hiddenHUD];
                    
                    //登陆
                    //跳转到主页面
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                    
                    [weakself.navigationController pushViewController:mainTabBarController animated:YES];

                    
                }else{
                    
                    
                    NSString *errorMsg = [loginXmlDoc objectForKey:@"statusmsg"];
                    
                    [weakself hiddenHUDWithMessage:errorMsg];

                }
                
                
            } requestFail:^(NSError *error) {
                
                [weakself hiddenHUDWithMessage:@"登陆失败"];
            }];
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            [weakself hiddenHUDWithMessage:errorMsg];
        }
    
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:@"验证失败"];

    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
