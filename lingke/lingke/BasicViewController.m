//
//  BasicViewController.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicViewController.h"

@implementation BasicViewController

- (void)hiddenSurplusLine:(UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}

@end
