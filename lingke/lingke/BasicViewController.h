//
//  BasicViewController.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Network.h"
#import "XMLDictionary.h"
#import "HomeappModel.h"
#import "HttpsRequestManger.h"
#import "LocalData.h"
#import "HomeFunctionModel.h"
#import "MBProgressHUD.h"


@interface BasicViewController : UIViewController<MBProgressHUDDelegate>

- (void)showHUD;

- (void)showHUDWithMessage:(NSString *)message;

- (void)hiddenHUD;

- (void)hiddenHUDWithMessage:(NSString *)message;

- (void)handErrorWihtErrorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg expireLoginSuccessBlock:(ExpireLoginSuccessBlock)expireLoginSuccessBlock expireLoginFailureBlock:(ExpireLoginFailureBlock)expireLoginFailureBlock;

@end
