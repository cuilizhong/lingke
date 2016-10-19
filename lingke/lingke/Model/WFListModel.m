//
//  WFListModel.m
//  lingke
//
//  Created by clz on 16/9/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "WFListModel.h"

@implementation WFListModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.formid = dic[@"formid"];
    
    self.wfname = dic[@"wfname"];
    
}

@end
