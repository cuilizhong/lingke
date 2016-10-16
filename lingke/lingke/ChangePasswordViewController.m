//
//  ChangePasswordViewController.m
//  lingke
//
//  Created by clz on 16/9/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign,nonatomic)BOOL isChangePasswordSuccess;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.submitButton.layer.cornerRadius = 5.0f;
    self.submitButton.clipsToBounds = YES;
    
    [self hiddenSurplusLine:self.tableView];
}

- (void)barButtonItemAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender {
    
    [self showHUDWithMessage:@"提交中"];
    
    if (self.oldPasswordTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写原密码"];
        
        return;
        
    }
    
    if (self.passwordTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写新密码"];
        
        return;
    }
    
    if (self.confirmTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写确认密码"];
        
        return;
    }
    
    if (![self.oldPasswordTextField.text isEqualToString:[LocalData getPassword]]) {
        
        [self hiddenHUDWithMessage:@"原密码填写错误"];
        
        return;
        
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmTextField.text]) {
        
        [self hiddenHUDWithMessage:@"两次新密码填写不一致"];
        
        return;
    }
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/dataapi/xml/changepwd",[LocalData getLoginInterface]];
    NSLog(@"url = %@",url);
    
    
    
    NSDictionary *parameter = @{
                                
                                @"mobile": [LocalData getMobile],
                                
                                @"unitcode":[LocalData getUnitcode],
                                
                                @"password":[LocalData getPassword],

                                @"newpwd":self.confirmTextField.text,
                                
                                @"clientos":@"ios",
                                
                                @"clientversion":[NSString stringWithFormat:@"ios%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]],
                                
                                @"clientid":[self getDeviceId]
                                
                                };
    
    @weakify(self);
    Network *network = [[Network alloc]initWithURL:url parameters:parameter requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
            
            weakself.isChangePasswordSuccess = YES;
            
            [weakself hiddenHUDWithMessage:@"密码修改成功"];
            
        }else{
            
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself submitAction:sender];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                weakself.isChangePasswordSuccess = NO;
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];
            
        }

        
    } requestFail:^(NSError *error) {
        
        NSLog(@"失败");
        
        weakself.isChangePasswordSuccess = NO;
        
        [weakself hiddenHUDWithMessage:@"修改失败"];

        
    }];

}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (self.isChangePasswordSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
