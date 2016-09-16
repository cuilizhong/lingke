//
//  UIViewController+viewControllerHelp.m
//  lingke
//
//  Created by clz on 16/9/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "UIViewController+viewControllerHelp.h"
#import <SSKeychain/SSKeychain.h>


@implementation UIViewController (viewControllerHelp)

- (void)hiddenSurplusLine:(UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
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
