//
//  UserinfoViewController.m
//  lingke
//
//  Created by clz on 16/9/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "UserinfoViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"


@interface UserinfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *unitNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *unitcodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;


@end

@implementation UserinfoViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self hiddenSurplusLine:self.tableView];
    
    
    self.logoutButton.layer.cornerRadius = 5.0f;
    self.logoutButton.clipsToBounds = YES;
    
    
    self.usernameTextField.text = [LocalData getUsername];
    
    self.phoneNumberTextField.text = [LocalData getMobile];
    
    self.unitNameTextField.text = [LocalData getUnitname];
    
    self.unitcodeTextField.text = [LocalData getUnitcode];
    
    
    
}

- (IBAction)logoutAction:(id)sender {
    
    [LocalData logout];
    
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}


@end
