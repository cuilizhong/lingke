//
//  BasicViewController.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController()

@property (nonatomic,strong)MBProgressHUD *progressHUD;

@end

@implementation BasicViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:window];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.progressHUD];
    
    self.progressHUD.delegate = self;
    

}

- (void)showHUD{
    
    [self.progressHUD showAnimated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    self.progressHUD.detailsLabel.text = nil;
    
}


- (void)showHUDWithMessage:(NSString *)message{
    
    [self.progressHUD showAnimated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    //    self.progressHUD.labelText = nil;
    
    self.progressHUD.detailsLabel.text = message;
    
    self.progressHUD.detailsLabel.font = [UIFont fontWithName:@"Arial" size:14];
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
        [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:expireLoginSuccessBlock expireLoginFailureBlock:expireLoginFailureBlock];
        
    }else{
        
        [self hiddenHUDWithMessage:errorMsg];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
