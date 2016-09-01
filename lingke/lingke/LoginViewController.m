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
#import <SSKeychain/SSKeychain.h>
#import "LocalData.h"
#import "UserinfoModel.h"
#import "GDataXMLNode.h"



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
    
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"image_1"]];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
    
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
        
         __weak typeof(self)weakSelf = self;
        
        [cell showCellWithEntrySystemBlock:^{
            
            [weakSelf requestForLogin];
            
            
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
        
        self.passwordTextField.text = @"password";
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
    
    
    if (self.unitcodeTextField.text.length<1) {
        
        
        return;
    }
    
    if (self.phoneNumberTextField.text.length<1) {
        
        return;
    }
    
    if (self.passwordTextField.text.length<1) {
        
        
        return;
    }
    
    NSDictionary *parameters = @{
                                 
                                 @"unitcode":self.unitcodeTextField.text,
                                 
                                 @"mobile":self.phoneNumberTextField.text
                                 
                                 };
    
    Network *verificationNetwork = [[Network alloc]initWithURL:verificationURL parameters:parameters requestSuccess:^(NSData *data) {
        
        NSString *xmlStr  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //xml文档类
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
        
        //得到根节点,maps节点
        GDataXMLElement *mapsEle = [doc rootElement];
        
        GDataXMLElement *responsedataEle = [[mapsEle elementsForName:@"responsedata"] lastObject];
        
        GDataXMLElement *serverinfoEle = [[responsedataEle elementsForName:@"serverinfo"] lastObject];
       
        GDataXMLElement *iphostEle = [[serverinfoEle elementsForName:@"iphost"]lastObject];
        
        GDataXMLElement *sslEle = [[serverinfoEle elementsForName:@"ssl"]lastObject];
        
        GDataXMLElement *pathEle = [[serverinfoEle elementsForName:@"path"]lastObject];
        
        GDataXMLElement *portEle = [[serverinfoEle elementsForName:@"port"]lastObject];
        
        NSString *iphost = iphostEle.stringValue;
        
        NSString *ssl = sslEle.stringValue;
        
        NSString *path = pathEle.stringValue;
        
        NSString *port = portEle.stringValue;

        
        NSString *loginInterface = [NSString stringWithFormat:@"%@://%@:%@%@",[ssl isEqualToString:@"no"]?@"http":@"https",iphost,port,path];
        
        //保存
        [LocalData setLoginInterface:loginInterface];
        

        NSLog(@"interface = %@",loginInterface);
        
        NSLog(@"xmlStr = %@",xmlStr);
        
        NSDictionary *loginParameters = @{
                                     
                                     @"unitcode":self.unitcodeTextField.text,
                                     
                                     @"mobile":self.phoneNumberTextField.text,
                                     
                                     @"password":self.passwordTextField.text,
                                     
                                     @"clientos":@"ios",

                                     @"clientversion":[NSString stringWithFormat:@"ios%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]],

                                     @"clientid":[self getDeviceId]
                                     
                                     };
        
        NSLog(@"loginParameters = %@",loginParameters);
        
        Network *loginNetwork = [[Network alloc]initWithURL:[NSString stringWithFormat:@"%@%@",loginInterface,loginURL] parameters:loginParameters requestSuccess:^(NSData *data) {
            
            NSString *xmlStr  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"xmlStr = %@",xmlStr);
            
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
            
            GDataXMLElement *mapsEle = [doc rootElement];
            
            GDataXMLElement *statuscodeEle = [[mapsEle elementsForName:@"statuscode"] lastObject];
            
            if ([statuscodeEle.stringValue isEqualToString:@"0"]) {
                //获取数据成功
                //登陆成功保存用户信息
                GDataXMLElement *responsedataEle = [[mapsEle elementsForName:@"responsedata"] lastObject];
                
                GDataXMLElement *sessioninfoEle = [[responsedataEle elementsForName:@"sessioninfo"]lastObject];

                GDataXMLElement *tokenEle = [[sessioninfoEle elementsForName:@"token"] lastObject];

                [LocalData setToken:tokenEle.stringValue];
                
                [LocalData setPhoneNumber:self.phoneNumberTextField.text];
                
                [LocalData setPassword:self.passwordTextField.text];
                
                [LocalData setUnitcode:self.unitcodeTextField.text];
                
                
                [[UserinfoModel sharedInstance]setValueFromResponsedataEle:responsedataEle];
                
                //跳转到主页面
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                
                [self.navigationController pushViewController:mainTabBarController animated:YES];
                
            }else{
                
                //弹出错误消息
                GDataXMLElement *statusmsgEle = [[mapsEle elementsForName:@"statusmsg"] lastObject];
                
                NSString *errorMsg = statusmsgEle.stringValue;

                NSLog(@"errorMsg = %@",errorMsg);
                
            }
            
        } requestFail:^(NSError *error) {
            
            NSLog(@"请求失败");
        }];
        
    } requestFail:^(NSError *error) {
        
        NSLog(@"请求失败");

    }];
    
}

/*
 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 
 MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
 
 [weakSelf.navigationController pushViewController:mainTabBarController animated:YES];
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@"com.Softtek.lingke"account:@"uuid"];
    
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@"com.Softtek.lingke"account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}
@end
