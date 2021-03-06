//
//  BasicTableViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicTableViewController.h"
#import "LoginViewController.h"


@interface BasicTableViewController()

@property (nonatomic,strong)MBProgressHUD *progressHUD;

@end

@implementation BasicTableViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:window];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.progressHUD];
    
    self.progressHUD.delegate = self;

}

- (void)showHUDWithMessage:(NSString *)message{
    
    [self.progressHUD showAnimated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    //    self.progressHUD.labelText = nil;
    
    self.progressHUD.detailsLabel.text = message;
    
    self.progressHUD.detailsLabel.font = [UIFont fontWithName:@"Arial" size:14];
}

- (void)showHUD{
    
    [self.progressHUD showAnimated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    self.progressHUD.detailsLabel.text = nil;
    
}

- (void)hiddenHUD{
    
    [self.progressHUD hideAnimated:YES];
}

- (void)hiddenHUDWithMessage:(NSString *)message{
    
    [self.progressHUD showAnimated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    
    self.progressHUD.detailsLabel.text = message;
    
    self.progressHUD.detailsLabel.font = [UIFont fontWithName:@"Arial" size:14];
    
    [self.progressHUD hideAnimated:YES afterDelay:2];
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
}

- (void)handErrorWihtErrorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg expireLoginSuccessBlock:(ExpireLoginSuccessBlock)expireLoginSuccessBlock expireLoginFailureBlock:(ExpireLoginFailureBlock)expireLoginFailureBlock{
    
    if ([errorCode isEqualToString:TokenInvalidCode]) {
        
        //token失效
        //重新登录
        @weakify(self);
        [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:expireLoginSuccessBlock expireLoginFailureBlock:^(NSString *errorMessage) {
            
            //自动登录失败
            LoginViewController *loginViewController = [[LoginViewController alloc]init];
            
            loginViewController.isInsideLogin = YES;
            
            [weakself presentViewController:loginViewController animated:NO completion:^{
                
            }];
            
            
        }];
        
    }else{
        
        [self hiddenHUDWithMessage:errorMsg];
        
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
